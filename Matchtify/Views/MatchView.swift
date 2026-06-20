//
//  MatchPageView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 19/06/26.
//

import SwiftUI

struct MatchView: View {
    @StateObject
    private var swipeModel = SwipeableCardsView.Model(
        cards: SongLibrary.songs.map {
            SwipeableCardsView.CardModel(song: $0)
        }
    )
    
    @EnvironmentObject var audioManager: AudioManager
    
    // Setup Genre List
    @State private var selectedGenre =
        Array(Set(SongLibrary.songs.map(\.genre))).sorted().first ?? ""
    
    private let genres = Array(
            Set(SongLibrary.songs.map(\.genre))
        ).sorted()
    
    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()

            // MARK: Header Area
            VStack(spacing: 24) {
                HStack {
                    Text("Match")
                        .font(.largeTitle.bold())
                    
                    Spacer()
                    
                    Image("ProfilePicture")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                
                // MARK: Scrollable Genres
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(genres, id: \.self) { genre in
                            Button {
                                selectedGenre = genre

                                swipeModel.replaceCards(
                                    with: SongLibrary.songs.filter {
                                        $0.genre == genre
                                    }
                                )
                            } label: {
                                Text(genre)
                                    .font(.footnote)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        selectedGenre == genre
                                        ? Color.indigo
                                        : Color(.quaternarySystemFill)
                                    )
                                    .foregroundStyle(
                                        selectedGenre == genre
                                        ? .white
                                        : .secondary
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
                
                // MARK: Card Area
                VStack {
                    SwipeableCardsView(
                        model: swipeModel,
                        audioManager: audioManager
                    ) { model in
                        model.reset()
                    }
                    .frame(height: 450)
                    
                    // Slider Player
                    VStack(spacing: 4) {
                        Slider(
                            value: audioManager.progressBinding,
                            in: 0...1,
                            onEditingChanged: audioManager.handleScrubbing
                        )
                        .tint(.indigo)
                        .disabled(audioManager.duration == 0)
                        
                        // Audio Time
                        HStack {
                            Text(audioManager.elapsedText)
                            Spacer()
                            Text(audioManager.remainingText)
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .frame(width: 280)
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    MatchView().environmentObject(AudioManager.preview)
}
