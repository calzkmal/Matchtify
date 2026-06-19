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

    @Binding var currentStep: Int
    var onNext: () -> Void = {}
    var onSkip: () -> Void = {}

    @StateObject private var audioManager: AudioManager
    @State private var scrubProgress: Double = 0
    @State private var isScrubbing = false

    let totalSteps: Int = 4
    
    init(
        song: Song,
        currentStep: Binding<Int>,
        onNext: @escaping () -> Void = {},
        onSkip: @escaping () -> Void = {}
    ) {
        self.song = song
        self._currentStep = currentStep
        self.onNext = onNext
        self.onSkip = onSkip

        _audioManager = StateObject(
            wrappedValue: AudioManager(song: song)
        )
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()
            // Container
            VStack (spacing: 32) {
                
                // Title
                VStack (spacing: 8) {
                    
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
                            onSkip()
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
                
                // Container
                VStack (spacing: 4) {
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
                            }
                            .glassEffect(.regular)
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
                    }
                    
                    VStack (spacing: 12) {
                        // Text
                        Text(song.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        // Song Label
                        HStack {
                            Text(song.artist)
                                .font(.callout)
                            
                            Text("·")
                                .font(.callout)
                            
                            Text("Soundtrack")
                                .font(.callout)
                            
                            Text("·")
                                .font(.callout)
                            
                            Text(String(song.year))
                                .font(.callout)
                        }
                        
                        Text(song.genre)
                            .font(.caption)
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.quaternary, in: Capsule())
                    }
                }
                
                
                // Button
                HStack (spacing: 16) {
                    // Dislike
                    Button {
                        currentStep += 1
                        onNext()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(.title, weight: .medium))
                            .foregroundStyle(Color.primary)
                            .frame(width: 80, height: 80)
                    }
                    // STYLE NYA GINI
                    .buttonStyle(.glassProminent)
                    .tint(Color.secondary.opacity(0.5))
                    .clipShape(Circle())
                    
                    // Like
                    Button {
                        currentStep += 1
                        onNext()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(.title, weight: .medium))
                            .foregroundStyle(Color.white)
                            .frame(width: 80, height: 80)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color.indigo)
                    .clipShape(Circle())
                }
            }
        }
    }
}

#Preview {
    if let song = SongLibrary.songs.first {
        MatchSong(song: song, currentStep: .constant(1))
        }
}
