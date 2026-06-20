//
//  CardView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 20/06/26.
//

import SwiftUI

struct CardView: View {

    let song: Song
    let isPlaying: Bool
    let onPlayTapped: () -> Void

    let albumSize: CGFloat = 280
    
    var body: some View {

        VStack(spacing: 24) {

            ZStack {
                Image(song.albumImage)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: 280,
                        height: 280
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 16
                        )
                    )
                Button {
                    onPlayTapped()
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.largeTitle)
                    .foregroundStyle(Color.primary)
                    .frame(width: 80, height: 80)
                }
                .buttonStyle(.glassProminent)
                .tint(Color.secondary.opacity(0.5))
                .clipShape(Circle())
            }
            
            VStack (spacing: 4) {
                Text(song.title)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 280)

                Text(song.artist)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.background)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20
            )
        )
        .overlay {
            RoundedRectangle(cornerRadius: 20)
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
