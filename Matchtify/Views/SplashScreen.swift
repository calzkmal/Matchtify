//
//  SplashScreen.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 17/06/26.
//

import SwiftUI

struct SplashScreen: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    // Setup for dynamic sizing on AlbumRows
    private var visibleRows: Int {
        switch dynamicTypeSize {
        case .accessibility2,
                .accessibility3,
                .accessibility4,
                .accessibility5:
            return 2
            
        case .accessibility1:
            return 3
        
        default:
            return 4
        }
    }
    
    // Setup on onboarding process to go to MatchView
    @AppStorage("hasCompletedOnboarding")
    private var hasCompletedOnboarding = false
    
    // AlbumRows container
    private var albumRows: [[String]] {

        let albums = SongLibrary.songs.map(\.albumImage)

        return stride(from: 0, to: albums.count, by: 3).map {
            Array(albums[$0..<min($0 + 3, albums.count)])
        }
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()
            
            // Container
            VStack (spacing: 56) {
                
                // Album
                VStack (spacing: 16) {
                    
                    // Albums
                    ForEach(Array(albumRows.prefix(visibleRows).enumerated()),
                            id: \.offset) { index, assets in
                        AlbumRowView(
                            assets: assets,
                            alignment: index.isMultiple(of: 2)
                                ? .leading
                                : .trailing
                        )
                    }
                }
                
                // Bottom Content
                VStack (spacing: 32) {
                    
                    // Text Container
                    VStack (spacing: 16) {
                        
                        // Text Title
                        Text("Enhance your listening experience in \(Text("5 mins.").foregroundStyle(Color.indigo))")
                            .font(.title)
                            .fontWeight(.semibold)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                
                    // Buttons
                    VStack (spacing: 8) {
                        
                        // Button Get Started
                        Button {
                            hasCompletedOnboarding = true
                        } label: {
                            Text("Get started")
                                .font(.headline)
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.glassProminent)
                        .tint(Color.indigo)
                        
                        // Button Log In
                        Button {
                            
                        } label: {
                            Text("Log in")
                                .font(.headline)
                                .foregroundStyle(Color.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        // STYLE NYA GINI
                        .buttonStyle(.glassProminent)
                        .tint(Color.secondary.opacity(0.5))
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

#Preview {
    SplashScreen()
}
