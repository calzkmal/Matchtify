//
//  HomePage.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 19/06/26.
//

import SwiftUI

struct HomePage: View {
    private let featuredSongs = Array(SongLibrary.songs.prefix(4))

    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Match")
                .font(.largeTitle.bold())

        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HomePage()
}
