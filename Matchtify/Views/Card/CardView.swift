//
//  CardView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 20/06/26.
//

import SwiftUI

struct CardView: View {

    let song: Song

    @EnvironmentObject var audioManager: AudioManager

    private let albumSize: CGFloat = 280

    var body: some View {

        VStack(spacing: 24) {

            ZStack {

                Image(song.albumImage)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: albumSize,
                        height: albumSize
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 16
                        )
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
                    .foregroundStyle(.primary)
                    .frame(
                        width: 80,
                        height: 80
                    )
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
                    .frame(width: albumSize)

                Text(song.artist)
                    .foregroundStyle(.secondary)
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
            .frame(width: albumSize)
        }
        .padding()
        .background(.background)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20
            )
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
    }
}
