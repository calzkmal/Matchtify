//
//  MatchSong.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 17/06/26.
//

import SwiftUI
import AVFoundation

struct MatchSong: View {
    @StateObject private var audioManager = AudioManager()
    
    let currentStep: Int = 1
    let totalSteps: Int = 4
    
    var body: some View {
        // Container
        VStack (spacing: 32) {
            
            // Title
            VStack {
                
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
                ZStack {
                    Image("asset-2")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 280, height: 280)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Button {
                        audioManager.togglePlayback()
                    } label: {
                        Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                            .font(.largeTitle)
                            .foregroundStyle(Color.primary)
                            .frame(width: 80, height: 80)
                            .background(.ultraThickMaterial)
                            .clipShape(.circle)
                    }
                }
            }
            
            // Button
            HStack {
                
            }
        }
    }
}

#Preview {
    MatchSong()
}
