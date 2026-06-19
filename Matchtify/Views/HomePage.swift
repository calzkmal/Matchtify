//
//  HomePage.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 19/06/26.
//

import SwiftUI

struct HomePage: View {
    private let songs = SongLibrary.songs
    private let totalSteps = 4

    @State private var currentSongIndex = 0
    @State private var currentStep = 1
    @State private var showingMatchSong = true

    private var currentSong: Song? {
        guard !songs.isEmpty else { return nil }
        return songs[currentSongIndex % songs.count]
    }

    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()

            if showingMatchSong, let currentSong {
                MatchSong(
                    song: currentSong,
                    currentStep: Binding(
                        get: { currentStep },
                        set: { newValue in
                            currentStep = newValue > totalSteps ? 1 : newValue
                        }
                    ),
                    onNext: advanceToNextSong,
                    onSkip: {
                        showingMatchSong = false
                    }
                )
                .id(currentSong.id)
            } else {
                VStack(spacing: 16) {
                    Text("HomePage")
                        .font(.largeTitle.bold())

                    Text("Your matching session is paused.")
                        .foregroundStyle(.secondary)

                    Button {
                        showingMatchSong = true
                    } label: {
                        Text("Start matching")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(.indigo)
                }
                .padding(.horizontal, 24)
            }
        }
    }

    private func advanceToNextSong() {
        guard !songs.isEmpty else { return }
        currentSongIndex = (currentSongIndex + 1) % songs.count
    }
}

#Preview {
    HomePage()
}
