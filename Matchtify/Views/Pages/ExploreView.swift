//
//  ExploreView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 19/06/26.
//

import SwiftUI

struct ExploreView: View {
    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()
            
            // MARK: Main Container
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
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    ExploreView()
}
