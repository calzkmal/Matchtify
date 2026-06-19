//
//  ContentView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 17/06/26.
//

import SwiftUI

struct ContentView: View {
    private let songs = SongLibrary.songs
    private let totalSteps = 4

    @AppStorage("hasCompletedOnboarding")
    private var hasCompletedOnboarding = false

    @State private var screen: AppScreen = .splash
    @State private var currentSongIndex = 0
    @State private var currentStep = 1

    init() {
        let completedOnboarding = UserDefaults.standard.bool(
            forKey: "hasCompletedOnboarding"
        )
        _screen = State(initialValue: completedOnboarding ? .home : .splash)
    }

    var body: some View {
        Group {
            switch screen {
            case .splash:
                SplashScreen {
                    hasCompletedOnboarding = true
                    currentSongIndex = 0
                    currentStep = 1
                    screen = .match
                }
            case .match:
                if let currentSong = currentSong {
                    MatchSong(
                        song: currentSong,
                        currentStep: Binding(
                            get: { currentStep },
                            set: { newValue in
                                if newValue > totalSteps {
                                    currentStep = 1
                                    screen = .home
                                } else {
                                    currentStep = newValue
                                }
                            }
                        ),
                        onNext: advanceToNextSong,
                        onSkip: {
                            currentStep = 1
                            screen = .home
                        }
                    )
                    .id(currentSong.id)
                } else {
                    HomePage()
                }
            case .home:
                HomePage()
            }
        }
    }

    private var currentSong: Song? {
        guard !songs.isEmpty else { return nil }
        return songs[currentSongIndex % songs.count]
    }

    private func advanceToNextSong() {
        guard !songs.isEmpty else { return }
        currentSongIndex = (currentSongIndex + 1) % songs.count
    }
}

private enum AppScreen {
    case splash
    case match
    case home
}

#Preview {
    ContentView()
}
