//
//  OnboardingView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 17/06/26.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var
    audioManager: AudioManager

    @State private var
    selectedAction: SwipeAction?
    
    @Binding var
    currentStep: Int

    var onNext: () -> Void = {}
    var onSkip: () -> Void = {}

    @StateObject
    private var swipeModel = SwipeableCardsViewModel(
        cards: SongLibrary.songs.map {
            SwipeableCardModel(song: $0)
        }
    )

    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()

            VStack(spacing: 24) {

                // MARK: Progress Bar
                VStack(spacing: 8) {
                    HStack {
                        ForEach(1...OnboardingModel.totalSteps, id: \.self) { step in
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
                        Text("Step \(currentStep) of \(OnboardingModel.totalSteps)")
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

                // MARK: Title
                Text("Does this track match \(Text("your taste?").foregroundStyle(.indigo))")
                    .font(.title)
                    .fontWeight(.semibold)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // MARK: Card Area
                SwipeableCardsView(
                    model: swipeModel,
                    audioManager: audioManager,
                    action: { model in
                        model.reset()
                    },
                    onCardSwiped: {
                        currentStep += 1
                        onNext()
                    },
                    allowsSwipeUp: false,
                )

                // MARK: Action Buttons
                HStack(spacing: 16) {
                    
                    // Left button
                    Button {
                        swipeModel.performSwipe(.dislike) {
                            currentStep += 1
                            onNext()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(.title, weight: .medium))
                            .foregroundStyle(swipeModel.previewAction == .dislike
                                             ? Color.white
                                             : Color.primary)
                            .frame(width: 64, height: 64)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(swipeModel.previewAction == .dislike
                          ? .indigo
                          : Color.secondary.opacity(0.5)
                    )
                    .scaleEffect(
                        swipeModel.previewAction == .dislike ? 1.15 : 1
                    )
                    .animation(.spring, value: swipeModel.previewAction)
                    .clipShape(Circle())
                    
                    // Right button
                    Button {
                        swipeModel.performSwipe(.like) {
                            currentStep += 1
                            onNext()
                        }
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(.title, weight: .medium))
                            .foregroundStyle(swipeModel.previewAction == .like
                                             ? Color.white
                                             : Color.primary)
                            .frame(width: 64, height: 64)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(swipeModel.previewAction == .like
                          ? .indigo
                          : Color.secondary.opacity(0.5)
                    )
                    .scaleEffect(
                        swipeModel.previewAction == .like ? 1.15 : 1
                    )
                    .animation(.spring, value: swipeModel.previewAction)
                    .clipShape(Circle())
                }
            }
            .padding(.horizontal, 24)
        }
    }

    private func advanceStep() {
        guard currentStep < OnboardingModel.totalSteps else { return }
        currentStep += 1
    }
}

#Preview {
    OnboardingView(
        currentStep: .constant(1)
    )
    .environmentObject(AudioManager.preview)
}
