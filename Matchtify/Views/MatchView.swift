//
//  MatchPageView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 19/06/26.
//

import SwiftUI

struct MatchPageView: View {
    private let featuredSongs = Array(SongLibrary.songs.prefix(4))

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
            }
            .padding(.horizontal, 24)
            
            // Row of Genres
            HStack {
                
            }
        }
    }
}

#Preview {
    MatchPageView()
}
