//
//  TopPickCardView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 21/06/26.
//

import SwiftUI

struct TopPickCardView: View {
    let song: Song

    @State private var toastManager = ToastManager()
    
    var body: some View {
        Button {
            toastManager.show(song.title)
        } label: {
            ZStack(alignment: .bottomLeading) {
                
                Image(song.albumImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 248, height: 320)
                    .clipped()
                
                // Overlay bawah yang blur dari album art
                ZStack(alignment: .bottomLeading) {
                    
                    Image(song.albumImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 140)
                        .blur(radius: 50)
                        .scaleEffect(1.3)
                        .mask {
                            LinearGradient(
                                colors: [.clear, .white],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                    
                    LinearGradient(
                        colors: [
                            .clear,
                            .black.opacity(0.1),
                            .black.opacity(0.6),
                            .black
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                        Text("New Release")
                            .font(.caption)
                        
                        Text(song.title)
                            .font(.title2.bold())
                            .lineLimit(1)
                        
                        Text(song.artist)
                            .font(.headline)
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    .foregroundStyle(.white)
                    .padding(20)
                }
            }
            .frame(width: 248, height: 320)
            .clipShape(
                RoundedRectangle(cornerRadius: 16)
            )
        }
        .toastOverlay(toastManager)
    }
}
#Preview {
    TopPickCardView(
        song: SongLibrary.songs[0]
    )
    .environmentObject(AudioManager.preview)
}
