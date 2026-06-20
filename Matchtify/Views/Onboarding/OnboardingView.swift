//
//  OnboardingView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 17/06/26.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var audioManager: AudioManager

    @Binding var currentStep: Int

    var onNext: () -> Void = {}
    var onSkip: () -> Void = {}

    let totalSteps: Int = 4

    @StateObject
    private var swipeModel = SwipeableCardsView.Model(
        cards: SongLibrary.songs.map {
            SwipeableCardsView.CardModel(song: $0)
        }
    )

    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()

            VStack(spacing: 32) {

                // MARK: Progress Bar
                VStack(spacing: 8) {
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

                    HStack {
                        Text("Step \(currentStep) of \(totalSteps)")
                            .font(.callout)
                            .foregroundStyle(Color.secondary)

                        Spacer()

                        Button {
                            onSkip()
                        } label: {
                            Text("Skip")
                                .font(.callout)
                                .foregroundStyle(Color.secondary)
                        }
                    }
                }
                .padding(.horizontal, 24)

                // MARK: Title
                Text("Does this track match \(Text("your taste?").foregroundStyle(.indigo))")
                    .font(.title)
                    .fontWeight(.semibold)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)

                // MARK: Card Stack
                SwipeableCardsView(
                    model: swipeModel,
                    audioManager: audioManager
                ) { model in
                    model.reset()
                } onCardSwiped: {

                    currentStep += 1

                    if currentStep <= totalSteps {
                        onNext()
                    }
                }
                .frame(height: 450)
                .padding(.horizontal, 24)

                // MARK: Action Buttons
                HStack(spacing: 16) {

                    Button {
                        swipeModel.swipeLeft()
                        
                        currentStep += 1
                        onNext()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(.title, weight: .medium))
                            .foregroundStyle(.primary)
                            .frame(width: 64, height: 64)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color.secondary.opacity(0.5))
                    .clipShape(Circle())

                    Button {
                        swipeModel.swipeRight()
                        
                        currentStep += 1
                        onNext()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(.title, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(width: 64, height: 64)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(.indigo)
                    .clipShape(Circle())
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }

    private func advanceStep() {
        guard currentStep < totalSteps else { return }
        currentStep += 1
    }
}

#Preview {
    OnboardingView(
        currentStep: .constant(1)
    )
    .environmentObject(AudioManager.preview)
}
