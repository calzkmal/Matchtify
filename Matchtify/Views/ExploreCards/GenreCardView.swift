//
//  GenreCardView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 21/06/26.
//

import SwiftUI

struct GenreCardView: View {
    let song: Song

    // Toast
    @State private var
    toastManager = ToastManager()
    
    var body: some View {
        Button {
            toastManager.show(song.title)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                
                Image(song.albumImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 8)
                    )
                
                VStack (alignment: .leading, spacing: 4){
                    Text(song.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.primary)
                        .lineLimit(1)
                    
                    Text(song.artist)
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                        .lineLimit(1)
                }
            }
            .frame(width: 200, alignment: .leading)
        }
        .toastOverlay(toastManager)
    }
}

#Preview {
    GenreCardView(
        song: SongLibrary.songs[0]
    )
    .environmentObject(AudioManager.preview)
}
