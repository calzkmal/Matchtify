//
//  SwipeableCardView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 20/06/26.
//

import SwiftUI
import Combine

struct SwipeableCardsView: View {
    typealias Model = SwipeableCardsModel
    typealias CardModel = SwipeableCardModel


    @ObservedObject
    var model: SwipeableCardsModel

    @ObservedObject
    var audioManager: AudioManager

    private let swipeThreshold: CGFloat = 100
    private let rotationFactor: Double = 35

    var action: (SwipeableCardsModel) -> Void
    var onCardSwiped: (() -> Void)? = nil

    var body: some View {
        Group {

            if model.unswipedCards.isEmpty &&
                model.swipedCards.isEmpty {

                EmptyCardsView()

            } else if model.unswipedCards.isEmpty {

                SwipeCompletionView(
                    model: model,
                    action: action
                )

            } else {

                cardsStack
            }
        }
        .onAppear(perform: loadCurrentSong)
        .onChange(
            of: model.unswipedCards.first?.id
        ) { _, _ in
            loadCurrentSong()
        }
    }
}

extension SwipeableCardsView {

    @ViewBuilder
    var cardsStack: some View {

        ZStack {

            ForEach(
                model.unswipedCards.reversed()
            ) { card in

                let isTop =
                    card == model.unswipedCards.first

                let isSecond =
                    card == model.unswipedCards
                        .dropFirst()
                        .first

                let revealProgress = min(
                    abs(model.dragState.width)
                    / swipeThreshold,
                    1
                )

                CardView(
                    song: card.song
                )
                .environmentObject(
                    audioManager
                )
                .scaleEffect(
                    isTop ? 1 :
                    isSecond ? 0.95 : 0.9
                )
                .opacity(
                    isTop ? 1 : revealProgress
                )
                .offset(
                    x: isTop
                    ? model.dragState.width
                    : 0,
                    y: isTop
                    ? 0
                    : isSecond ? 10 : 20
                )
                .rotationEffect(
                    .degrees(
                        isTop
                        ? Double(
                            model.dragState.width
                        ) / rotationFactor
                        : 0
                    )
                )
                .gesture(
                    isTop
                    ? dragGesture
                    : nil
                )
            }
        }
        // TODO: BENERIN INI COKKKK
        .frame(maxWidth: .infinity)
    }
}

extension SwipeableCardsView {

    var dragGesture: some Gesture {

        DragGesture()

            .onChanged { gesture in

                model.dragState =
                    gesture.translation
            }

            .onEnded { _ in

                if abs(
                    model.dragState.width
                ) > swipeThreshold {

                    model.swipe(
                        model.dragState.width > 0
                        ? .right
                        : .left,
                        completion: onCardSwiped
                    )

                } else {

                    withAnimation(
                        .spring(
                            response: 0.4,
                            dampingFraction: 0.8
                        )
                    ) {

                        model.dragState = .zero
                    }
                }
            }
    }
}

extension SwipeableCardsView {

    func loadCurrentSong() {

        guard let song =
            model.unswipedCards.first?.song
        else {
            return
        }

        audioManager.loadSong(
            song
        )
    }
}
