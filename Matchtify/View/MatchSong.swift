//
//  MatchSong.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 17/06/26.
//

import SwiftUI

struct MatchSong: View {
    let currentStep: Int = 1
    let totalSteps: Int = 4
    
    var body: some View {
        // Title
        VStack (spacing: 32) {
            // Progress Bar
            HStack {
                ForEach(1...totalSteps, id: \.self) { step in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(step <= currentStep ? .indigo : .secondary)
                        .frame(height: 8)
                }
            }
            
            // Step Text
            HStack {
                Text("Step \(currentStep) of \(totalSteps)")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Skip")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.secondary)
                }
            }
        }
        .padding(.horizontal, 24)
        
        // Text Title
        Text("Does this track match \(Text("your taste?").foregroundStyle(Color.indigo))")
            .font(.title)
            .fontWeight(.semibold)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
        
        // Card
        VStack {
            
        }
        
        // Button
        HStack {
            
        }
    }
}

#Preview {
    MatchSong()
}
