//
//  AV.swift
//  Matchtify
//

import AVFoundation
import Combine

@MainActor
final class AudioManager: ObservableObject {

    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    
    private let song: Song

    private let engine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()

    private var audioFile: AVAudioFile?
    private var sampleRate: Double = 44100
    private var totalFrames: AVAudioFramePosition = 0
    private var isSeeking: Bool = false

    // Frame where the *current* scheduled segment starts.
    // Player node's internal sample time resets to 0 every time we stop()+reschedule,
    // so we add this offset back in to get a real position in the song.
    private var seekFrameOffset: AVAudioFramePosition = 0

    private var displayTimer: Timer?

    init(song: Song) {
        self.song = song
        
        engine.attach(playerNode)
        loadSong()
    }

    private func loadSong() {
        guard let url = Bundle.main.url(
            forResource: song.audioFile,
            withExtension: "mp3")
        else {
            print("Song not found")
            return
        }

        do {
            let file = try AVAudioFile(forReading: url)
            audioFile = file
            sampleRate = file.fileFormat.sampleRate
            totalFrames = file.length
            duration = Double(totalFrames) / sampleRate

            engine.connect(playerNode, to: engine.mainMixerNode, format: file.processingFormat)
            try engine.start()

            scheduleFile(from: 0)
        } catch {
            print("Failed to load song: \(error.localizedDescription)")
        }
    }

    private func scheduleFile(from frame: AVAudioFramePosition) {
        guard let file = audioFile, totalFrames - frame > 0 else { return }

        seekFrameOffset = frame
        let framesToPlay = AVAudioFrameCount(totalFrames - frame)

        playerNode.scheduleSegment(
            file,
            startingFrame: frame,
            frameCount: framesToPlay,
            at: nil
        )
    }

    private func handlePlaybackFinished() {
        stopDisplayTimer()

        isPlaying = false
        currentTime = 0

        playerNode.stop()
        scheduleFile(from: 0)
    }

    func togglePlayback() {
        guard audioFile != nil else { return }
        isPlaying ? pause() : play()
    }

    private func play() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error.localizedDescription)
        }

        if !engine.isRunning {
            try? engine.start()
        }

        playerNode.play()
        isPlaying = true
        startDisplayTimer()
    }

    private func pause() {
        playerNode.pause()
        isPlaying = false
        stopDisplayTimer()
        currentTime = currentPlaybackTime()
    }

    func seek(to fraction: Double) {
        guard totalFrames > 0 else { return }

        let clamped = min(max(fraction, 0), 1)

        let targetFrame = AVAudioFramePosition(
            Double(totalFrames) * clamped
        )

        let wasPlaying = isPlaying

        playerNode.stop()

        scheduleFile(from: targetFrame)

        currentTime = Double(targetFrame) / sampleRate

        if wasPlaying {
            playerNode.play()
        }
    }

    private func currentPlaybackTime() -> TimeInterval {
        guard let nodeTime = playerNode.lastRenderTime,
              let playerTime = playerNode.playerTime(forNodeTime: nodeTime) else {
            return Double(seekFrameOffset) / sampleRate
        }

        let elapsedFrames = seekFrameOffset + playerTime.sampleTime
        return Double(elapsedFrames) / sampleRate
    }

    private func startDisplayTimer() {
        stopDisplayTimer()

        displayTimer = Timer.scheduledTimer(
            withTimeInterval: 0.1,
            repeats: true
        ) { [weak self] _ in

            Task { @MainActor [weak self] in
                guard let self, self.isPlaying else { return }

                let playbackTime = min(
                    self.currentPlaybackTime(),
                    self.duration
                )

                self.currentTime = playbackTime

                if playbackTime >= self.duration - 0.1 {
                    self.handlePlaybackFinished()
                }
            }
        }
    }

    private func stopDisplayTimer() {
        displayTimer?.invalidate()
        displayTimer = nil
    }

    var progress: Double {
        guard duration > 0 else { return 0 }
        return min(currentTime / duration, 1)
    }

    var elapsedText: String { Self.format(time: currentTime) }

    var remainingText: String {
        guard duration > 0 else { return "0:00" }
        return "-" + Self.format(time: max(duration - currentTime, 0))
    }

    private static func format(time: TimeInterval) -> String {
        guard time.isFinite else { return "0:00" }
        let totalSeconds = Int(time.rounded(.down))
        return String(format: "%d:%02d", totalSeconds / 60, totalSeconds % 60)
    }

    deinit {
        displayTimer?.invalidate()
    }
}
