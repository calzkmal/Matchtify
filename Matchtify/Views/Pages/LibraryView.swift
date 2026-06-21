//
//  ExploreView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 19/06/26.
//

import SwiftUI

struct LibraryView: View {
    private var songsByGenre: [String: [Song]] {
        Dictionary(grouping: SongLibrary.songs) { $0.genre }
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    // Popup profile
    @State private var showProfileSheet = false
    
    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()
            
            // MARK: Main Container
            ScrollView {
                
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: Header Area
                    HStack {
                        Text("Match")
                            .font(.largeTitle.bold())
                        
                        Spacer()
                        
                        Button {
                            showProfileSheet = true
                        } label: {
                            Image("ProfilePicture")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                        .sheet(isPresented: $showProfileSheet) {
                            ProfileSheetView()
                                .presentationSizing(.page)
                        }
                    }

                    // Lists
                    VStack(spacing: 0) {
                        LibraryRowComponent(
                            title: "Liked Songs",
                            icon: "heart.fill"
                        )

                        Divider()

                        LibraryRowComponent(
                            title: "Albums",
                            icon: "rectangle.stack"
                        )
                    }
                    
                    // Songs Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Songs")
                            .font(.title2.bold())

                        LazyVGrid(
                            columns: columns,
                            alignment: .leading,
                            spacing: 24
                        ) {
                            ForEach(SongLibrary.songs) { song in
                                GenreCardView(
                                    song: song,
                                    imageSize: 168
                                )
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    LibraryView()
        .environment(AppState())
}
