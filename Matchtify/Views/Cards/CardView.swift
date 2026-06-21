//
//  CardView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 20/06/26.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject var audioManager: AudioManager

    @State
    private var highlightTask: Task<Void, Never>?
    
    @State
    private var isHighlighted = false
    
    let song: Song

    var body: some View {

        VStack(spacing: 24) {

            ZStack {
                Image(song.albumImage)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )
                    .padding(.horizontal, 24)
                
                Button {
                    audioManager.togglePlayback()
                    isHighlighted = true
                    highlightTask?.cancel()
                    highlightTask = Task {
                        try? await Task.sleep(for: .seconds(0.5))

                        await MainActor.run {
                            isHighlighted = false
                        }
                    }
                } label: {
                    Image(
                        systemName:
                            audioManager.isPlaying
                            ? "pause.fill"
                            : "play.fill"
                    )
                    .font(.largeTitle)
                    .foregroundStyle(
                        isHighlighted ? Color.white : Color.primary
                    )
                    .frame(width: 80, height: 80)
                }
                .buttonStyle(.glassProminent)
                .tint(
                    isHighlighted ? Color.indigo : Color.secondary.opacity(0.8)
                )
                .animation(.easeInOut(duration: 0.25), value: isHighlighted)
                .clipShape(Circle())
            }

            VStack(spacing: 8) {
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
                .padding(.horizontal, 24)

                HStack {
                    Text(
                        audioManager.elapsedText
                    )
                    Spacer()
                    Text(
                        audioManager.remainingText
                    )
                }
                .padding(.horizontal, 24)
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.background)
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 24
            )
            .stroke(
                .primary.opacity(0.2),
                lineWidth: 1
            )
        }
        .shadow(
            color: .black.opacity(0.08),
            radius: 10,
            y: 0
        )
    }
}

#Preview {
    CardView(
        song: SongLibrary.songs[0]
    )
    .environmentObject(AudioManager.preview)
}
