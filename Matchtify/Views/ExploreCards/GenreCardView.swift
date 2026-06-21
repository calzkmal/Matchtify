//
//  GenreCardView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 21/06/26.
//

import SwiftUI

struct GenreCardView: View {
    let song: Song

    var body: some View {
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
                    .lineLimit(1)
                
                Text(song.artist)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .frame(width: 200, alignment: .leading)
    }
}

#Preview {
    GenreCardView(
        song: SongLibrary.songs[0]
    )
    .environmentObject(AudioManager.preview)
}
