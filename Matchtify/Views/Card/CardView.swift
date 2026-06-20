//
//  CardView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 20/06/26.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject var audioManager: AudioManager

    let song: Song

    var body: some View {

        VStack(spacing: 32) {

            ZStack {
                Image(song.albumImage)
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )

                Button {
                    audioManager.togglePlayback()
                } label: {
                    Image(
                        systemName:
                            audioManager.isPlaying
                            ? "pause.fill"
                            : "play.fill"
                    )
                    .font(.largeTitle)
                    .foregroundStyle(Color.primary)
                    .frame(width: 80,height: 80)
                }
                .buttonStyle(.glassProminent)
                .tint(
                    Color.secondary.opacity(0.5)
                )
                .clipShape(Circle())
            }

            VStack(spacing: 4) {
                Text(song.title)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                HStack {
                    Text(song.artist)
                        .foregroundStyle(.secondary)
                    
                    Text("·")
                        .foregroundStyle(.secondary)
                    
                    Text(String(song.year))
                        .foregroundStyle(.secondary)
                }
            }

            VStack(spacing: 4) {
                Slider(
                    value: audioManager.progressBinding,
                    in: 0...1,
                    onEditingChanged:
                        audioManager.handleScrubbing
                )
                .tint(.indigo)
                .disabled(
                    audioManager.duration == 0
                )

                HStack {
                    Text(
                        audioManager.elapsedText
                    )
                    Spacer()
                    Text(
                        audioManager.remainingText
                    )
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .aspectRatio(0.82, contentMode: .fit)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.background)
        )
        .overlay {

            RoundedRectangle(
                cornerRadius: 20
            )
            .stroke(
                .primary.opacity(0.2),
                lineWidth: 1
            )
        }
        .shadow(
            color: .black.opacity(0.08),
            radius: 10,
            y: 4
        )
        .padding(.horizontal, 24)
    }
}

#Preview {
    CardView(
        song: SongLibrary.songs[0]
    )
    .environmentObject(AudioManager.preview)
}
