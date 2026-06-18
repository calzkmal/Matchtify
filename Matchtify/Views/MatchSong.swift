//
//  MatchSong.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 17/06/26.
//

import SwiftUI
import AVFoundation

struct MatchSong: View {
    let song: Song
    
    @StateObject private var audioManager: AudioManager
    @State private var scrubProgress: Double = 0
    @State private var isScrubbing = false
    
    let currentStep: Int = 1
    let totalSteps: Int = 4
    
    init(song: Song) {
        self.song = song

        _audioManager = StateObject(
            wrappedValue: AudioManager(song: song)
        )
    }
    
    var body: some View {
        // Container
        VStack (spacing: 32) {
            
            // Title
            VStack (spacing: 4) {
                
                // Progress Bar
                HStack {
                    ForEach(1...totalSteps, id: \.self) { step in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                step <= currentStep
                                ? Color.indigo
                                : Color(uiColor: .quaternaryLabel)
                            )
                            .frame(height: 4)
                    }
                }
                
                // Step Text
                HStack {
                    Text("Step \(currentStep) of \(totalSteps)")
                        .font(.callout)
                        .foregroundStyle(Color.primary)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("Skip")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(uiColor: .secondaryLabel))
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
                    Image(song.albumImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 280, height: 280)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(.primary.opacity(0.3))
                        }
                    
                    // Play Audio
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
                
                // Slider Player
                VStack(spacing: 4) {
                    Slider(
                        value: Binding(
                            get: {
                                isScrubbing
                                    ? scrubProgress
                                    : audioManager.progress
                            },
                            set: { newValue in
                                scrubProgress = newValue
                            }
                        ),
                        in: 0...1,
                        onEditingChanged: { editing in
                            if editing {
                                isScrubbing = true
                                scrubProgress = audioManager.progress
                            } else {
                                audioManager.seek(to: scrubProgress)
                                isScrubbing = false
                            }
                        }
                    )
                    .tint(.indigo)
                    .disabled(audioManager.duration == 0)
                    
                    // Audio Time
                    HStack {
                        Text(audioManager.elapsedText)
                        Spacer()
                        Text(audioManager.remainingText)
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .frame(width: 280)
                .padding(.top, 8)
            }
            
            // Text
            Text(song.title)
            
            // Button
            HStack {
                
            }
        }
    }
}

#Preview {
    MatchSong(song: SongLibrary.randomSong)
}
