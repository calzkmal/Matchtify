//
//  ExploreView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 19/06/26.
//

import SwiftUI

struct ExploreView: View {
    private var songsByGenre: [String: [Song]] {
        Dictionary(grouping: SongLibrary.songs) { $0.genre }
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()
            
            // MARK: Main Container
            ScrollView {
                VStack (spacing: 32) {
                    
                    VStack {
                        
                        // MARK: Header Area
                        HStack {
                            Text("Explore")
                                .font(.largeTitle.bold())
                            
                            Spacer()
                            
                            Image("ProfilePicture")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                    }
                    // MARK: Container Padding
                    .padding(.horizontal)
                    
                    // MARK: - Top Pick
                    VStack (spacing: 12) {
                        VStack {
                            HStack {
                                Text("Tracks picked for you")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(SongLibrary.songs) { song in
                                    TopPickCardView(song: song)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                    
                    // MARK: - Per genres
                    LazyVStack(spacing: 48) {
                        ForEach(
                            songsByGenre.keys.sorted(),
                            id: \.self
                        ) { genre in
                            
                            VStack(spacing: 12) {
                                
                                HStack {
                                    Text(genre)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(songsByGenre[genre] ?? []) { song in
                                            GenreCardView(song: song)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ExploreView()
}
