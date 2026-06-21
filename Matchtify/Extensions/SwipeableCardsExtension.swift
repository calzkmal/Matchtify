//
//  SwipeableCardsExtension.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 21/06/26.
//

import SwiftUI

extension SwipeableCardsView {

    @ViewBuilder
    var cardsStack: some View {
        ZStack {
            ForEach(
                model.unswipedCards.reversed()
            ) { card in
                let isTop = card == model.unswipedCards.first
                let isSecond = card == model.unswipedCards.dropFirst().first
                
                // MARK: Animation for card swiping
                let revealProgress = min(
                    max(
                        abs(model.dragState.width),
                        abs(model.dragState.height)
                    ) / swipeThreshold, 1)

                CardView(song: card.song)
                    .environmentObject(audioManager)
                    .scaleEffect(isTop ? 1 : isSecond ? 0.95 : 0.9)
                    .opacity(isTop ? 1 : revealProgress)
                    .offset(
                        x: isTop ? model.dragState.width : 0,
                        y: isTop ? model.dragState.height : isSecond ? stackedCardOffset : stackedCardOffset * 2
                    )
                    .rotationEffect(
                        .degrees(
                            isTop ? Double(model.dragState.width) / rotationFactor : 0
                        )
                    )
                    .gesture(isTop ? dragGesture : nil)
            }
        }
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
                if model.dragState.height < -swipeThreshold {
                    onSwipeDirection?(.up)
                    model.swipe(
                        .up,
                        completion: onCardSwiped
                    )
                } else if abs(model.dragState.width) > swipeThreshold {
                    let direction: SwipeDirection =
                        model.dragState.width > 0 ? .right : .left
                    onSwipeDirection?(direction)
                    model.swipe(
                        direction,
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

extension SwipeableCardsViewModel {

    func performSwipe(
        _ action: SwipeAction,
        completion: (() -> Void)? = nil
    ) {

        switch action {

        case .dislike:
            swipeLeft {
                completion?()
            }

        case .like:
            swipeRight {
                completion?()
            }

        case .favorite:
            swipeUp {
                completion?()
            }
        }
    }
}
