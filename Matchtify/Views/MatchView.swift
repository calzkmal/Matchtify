//
//  MatchPageView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 19/06/26.
//

import SwiftUI

struct MatchView: View {
    // MARK: Setup Area
    // Setup Genre List
    @State private var selectedGenre: String?
    @EnvironmentObject private var audioManager: AudioManager
    private let genres = Array(
            Set(SongLibrary.songs.map(\.genre))
        ).sorted()

    // Setup for grabbing which song to display
    @State private var currentSong: Song?
    
    private var filteredSongs: [Song] {
        SongLibrary.songs.filter {
            $0.genre == selectedGenre
        }
    }

    // Randomize song
    private var randomSong: Song? {
        filteredSongs.randomElement()
    }
    
    // Grab the random song
    private func pickRandomSong() {
        currentSong = SongLibrary.songs
            .filter { $0.genre == selectedGenre }
            .randomElement()
    }
    
    private func nextSong() {
        currentSong = SongLibrary.songs
            .filter { $0.genre == selectedGenre }
            .randomElement()
    }
    
    init() {
            let genres = Array(
                Set(SongLibrary.songs.map(\.genre))
            ).sorted()

            _selectedGenre = State(initialValue: genres.first ?? "")
        }
    
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
                
                // MARK: Scroll Genres Area
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(genres, id: \.self) { genre in
                            Button {
                                selectedGenre = genre
                                pickRandomSong()
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
                if let song = currentSong {
                    let isCurrentSongLoaded = audioManager.currentSong?.id == song.id
                    ZStack {
                        Image(song.albumImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 354, height: 456)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(.primary.opacity(0.3))
                            }

                        Button {
                            audioManager.togglePlayback()
                        } label: {
                            Image(systemName: isCurrentSongLoaded && audioManager.isPlaying ? "pause.fill" : "play.fill")
                                .font(.largeTitle)
                                .foregroundStyle(Color.primary)
                                .frame(width: 80, height: 80)
                        }
                        .buttonStyle(.glassProminent)
                        .tint(Color.secondary.opacity(0.5))
                        .clipShape(Circle())
                    }
                }
                else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.quaternary)
                        .frame(width: 300, height: 300)
                        .overlay {
                            Text("No songs available")
                                .foregroundStyle(.secondary)
                        }
                }
                
            } // end of vstack
            .onAppear {
                pickRandomSong()
            }
            .onChange(of: currentSong?.id) { _, newValue in
                guard newValue != nil, let song = currentSong else { return }
                audioManager.load(song: song)
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    MatchView()
        .environmentObject(AudioManager())
}
