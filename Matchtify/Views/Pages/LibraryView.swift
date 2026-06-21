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
                            Text("Library")
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
                    
                    
                }
            }
        }
    }
}

#Preview {
    LibraryView()
}
