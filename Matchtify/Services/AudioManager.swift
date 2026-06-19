//
//  AudioManager.swift
//  Matchtify
//

import AVFoundation
import SwiftUI
import Combine

@MainActor
final class AudioManager: ObservableObject {

    // MARK: - Published Properties

    @Published var currentSong: Song
    @Published var isPlaying = false

    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0

    @Published var isScrubbing = false
    @Published var scrubProgress: Double = 0

    // MARK: - Audio Engine

    private let engine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()

    private var audioFile: AVAudioFile?
    private var sampleRate: Double = 44100
    private var totalFrames: AVAudioFramePosition = 0
    private var seekFrameOffset: AVAudioFramePosition = 0

    private var displayTimer: Timer?

    // MARK: - Init

    init(song: Song) {
        self.currentSong = song

        engine.attach(playerNode)
        engine.connect(
            playerNode,
            to: engine.mainMixerNode,
            format: nil
        )

        try? engine.start()

        loadSongFile(song)
    }

    // MARK: - Song Management

    func loadSong(_ song: Song) {

        guard currentSong.id != song.id else {
            return
        }

        currentSong = song

        playerNode.stop()
        stopDisplayTimer()

        currentTime = 0
        seekFrameOffset = 0

        loadSongFile(song)

        if isPlaying {
            play()
        }
    }

    func loadRandomSong(for genre: String) {

        guard let randomSong =
            SongLibrary.songs
                .filter({ $0.genre == genre })
                .randomElement()
        else {
            return
        }

        loadSong(randomSong)
    }

    private func loadSongFile(_ song: Song) {

        guard let url = Bundle.main.url(
            forResource: song.audioFile,
            withExtension: "mp3"
        ) else {
            print("Song not found")
            return
        }

        do {
            let file = try AVAudioFile(forReading: url)

            audioFile = file
            sampleRate = file.fileFormat.sampleRate
            totalFrames = file.length

            duration = Double(totalFrames) / sampleRate

            scheduleFile(from: 0)

        } catch {
            print("Failed to load song: \(error.localizedDescription)")
        }
    }

    // MARK: - Playback Controls

    func togglePlayback() {
        guard audioFile != nil else { return }

        isPlaying ? pause() : play()
    }

    func play() {

        do {
            try AVAudioSession.sharedInstance()
                .setCategory(.playback, mode: .default)

            try AVAudioSession.sharedInstance()
                .setActive(true)

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

    func pause() {

        playerNode.pause()

        isPlaying = false

        stopDisplayTimer()

        currentTime = currentPlaybackTime()
    }

    private func handlePlaybackFinished() {

        stopDisplayTimer()

        isPlaying = false
        currentTime = 0

        playerNode.stop()

        scheduleFile(from: 0)
    }

    // MARK: - Seeking

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

    func handleScrubbing(_ editing: Bool) {

        if editing {

            isScrubbing = true

            scrubProgress = progress

        } else {

            seek(to: scrubProgress)

            isScrubbing = false
        }
    }

    private func currentPlaybackTime() -> TimeInterval {

        guard let nodeTime = playerNode.lastRenderTime,
              let playerTime = playerNode.playerTime(
                forNodeTime: nodeTime
              )
        else {
            return Double(seekFrameOffset) / sampleRate
        }

        let elapsedFrames = seekFrameOffset + playerTime.sampleTime

        return Double(elapsedFrames) / sampleRate
    }

    private func scheduleFile(from frame: AVAudioFramePosition) {

        guard let file = audioFile,
              totalFrames - frame > 0
        else {
            return
        }

        seekFrameOffset = frame

        let framesToPlay =
            AVAudioFrameCount(totalFrames - frame)

        playerNode.scheduleSegment(
            file,
            startingFrame: frame,
            frameCount: framesToPlay,
            at: nil
        )
    }

    // MARK: - Timer

    private func startDisplayTimer() {

        stopDisplayTimer()

        displayTimer = Timer.scheduledTimer(
            withTimeInterval: 0.1,
            repeats: true
        ) { [weak self] _ in

            Task { @MainActor [weak self] in

                guard let self,
                      self.isPlaying
                else {
                    return
                }

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

    // MARK: - Computed Properties

    var progress: Double {

        guard duration > 0 else {
            return 0
        }

        return min(currentTime / duration, 1)
    }

    var sliderProgress: Double {
        isScrubbing ? scrubProgress : progress
    }

    var progressBinding: Binding<Double> {

        Binding(
            get: {
                self.sliderProgress
            },
            set: {
                self.scrubProgress = $0
            }
        )
    }

    var elapsedText: String {
        Self.format(time: currentTime)
    }

    var remainingText: String {

        guard duration > 0 else {
            return "0:00"
        }

        return "-" + Self.format(
            time: max(duration - currentTime, 0)
        )
    }

    // MARK: - Helpers

    private static func format(
        time: TimeInterval
    ) -> String {

        guard time.isFinite else {
            return "0:00"
        }

        let totalSeconds = Int(time.rounded(.down))

        return String(
            format: "%d:%02d",
            totalSeconds / 60,
            totalSeconds % 60
        )
    }

    // MARK: - Deinit

    deinit {
        displayTimer?.invalidate()
    }
}

// MARK: - Preview

extension AudioManager {

    static let preview = AudioManager(
        song: SongLibrary.songs[0]
    )
}
