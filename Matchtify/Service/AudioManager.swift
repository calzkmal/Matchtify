//
//  AV.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 18/06/26.
//

import AVFoundation
import Combine

@MainActor
final class AudioManager: ObservableObject {

    @Published var isPlaying = false

    private var player: AVPlayer?
    private var endObserver: NSObjectProtocol?

    init() {
        loadSong()
    }

    private func loadSong() {
        guard let url = Bundle.main.url(forResource: "song-1", withExtension: "mp3") else {
            print("Song not found")
            return
        }

        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)

        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.isPlaying = false
            }
        }
    }

    deinit {
        if let endObserver {
            NotificationCenter.default.removeObserver(endObserver)
        }
    }

    func togglePlayback() {
        guard let player else { return }

        if player.isPlaying {
            player.pause()
            isPlaying = false
        } else {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print(error.localizedDescription)
            }

            player.play()
            isPlaying = true
        }
    }
}

private extension AVPlayer {
    var isPlaying: Bool {
        timeControlStatus == .playing
    }
}
