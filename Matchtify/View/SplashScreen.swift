//
//  SplashScreen.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 17/06/26.
//

import SwiftUI

struct SplashScreen: View {
    private let albumRows = [
        ["asset-1", "asset-2", "asset-3"],
        ["asset-4", "asset-5", "asset-6"],
        ["asset-7", "asset-8", "asset-9"],
        ["asset-10", "asset-11", "asset-12"]
    ]
    
    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()
            
            // Container
            VStack (spacing: 56) {
                
                // Album
                VStack (spacing: 16) {
                    
                    // Albums
                    ForEach(albumRows.indices, id: \.self) { index in

                        AlbumRowView(
                            assets: albumRows[index],
                            alignment: index.isMultiple(of: 2)
                                ? .leading
                                : .trailing
                        )

                    }
                }
                
                // Bottom Content
                VStack (spacing: 32) {
                    
                    // Texts
                    VStack (spacing: 16) {
                        
                        // Text Title
                        Text("Enhance your listening experience in \(Text("5 mins.").foregroundStyle(Color.indigo))")
                            .font(.title)
                            .fontWeight(.semibold)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                
                    // Buttons
                    VStack (spacing: 16) {
                        
                        // Button Get Started
                        Button {
                            
                        } label: {
                            Text("Get started")
                                .font(.headline)
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.glassProminent)
                        .tint(Color.indigo)
                        
                        // Button Log In
                        Button {
                            
                        } label: {
                            Text("Log in")
                                .font(.headline)
                                .foregroundStyle(Color.primary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.glass)
                        .tint(.clear)
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
