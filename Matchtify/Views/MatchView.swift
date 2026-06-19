//
//  MatchPageView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 19/06/26.
//

import SwiftUI

struct MatchView: View {
    @EnvironmentObject var audioManager: AudioManager
    
    // Setup Genre List
    @State private var selectedGenre: String?
    
    private let genres = Array(
            Set(SongLibrary.songs.map(\.genre))
        ).sorted()
    
    private let albumSize: CGFloat = 280
    
    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()

            // Header Area
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
                
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(genres, id: \.self) { genre in
                            Button {
                                selectedGenre = genre
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
                    ZStack {
                        Image(audioManager.song.albumImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: albumSize, height: albumSize)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(.primary.opacity(0.3))
                            }
                        
                        // Play Audio
                        Button {
                            audioManager.togglePlayback()
                        } label: {
                            Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                                .font(.largeTitle)
                                .foregroundStyle(Color.primary)
                                .frame(width: 80, height: 80)
                        }
                        .glassEffect(.regular)
                    }
                    
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
