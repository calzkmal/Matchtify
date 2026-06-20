//
//  SwipeableCardsModel.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 20/06/26.
//

import SwiftUI
import Combine

@MainActor
final class SwipeableCardsModel: ObservableObject {

    private var originalCards: [SwipeableCardModel]

    @Published var dragState = CGSize.zero

    @Published var unswipedCards: [SwipeableCardModel]

    @Published var swipedCards: [SwipeableCardModel]

    private let dismissDistance: CGFloat = 1000

    init(cards: [SwipeableCardModel]) {

        originalCards = cards
        unswipedCards = cards
        swipedCards = []
    }

    func updateTopCardSwipeDirection(
        _ direction: SwipeDirection
    ) {

        guard !unswipedCards.isEmpty else {
            return
        }

        unswipedCards[0].swipeDirection = direction
    }

    func removeTopCard() {

        guard !unswipedCards.isEmpty else {
            return
        }

        let card = unswipedCards.removeFirst()

        swipedCards.append(card)
    }

    func swipe(
        _ direction: SwipeDirection,
        completion: (() -> Void)? = nil
    ) {

        guard !unswipedCards.isEmpty else {
            return
        }

        updateTopCardSwipeDirection(direction)

        withAnimation(
            .easeOut(duration: 0.4)
        ) {

            dragState.width =
                direction == .right
                ? dismissDistance
                : -dismissDistance
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.4
        ) {

            self.removeTopCard()

            self.dragState = .zero

            completion?()
        }
    }

    func swipeLeft(
        completion: (() -> Void)? = nil
    ) {

        swipe(
            .left,
            completion: completion
        )
    }

    func swipeRight(
        completion: (() -> Void)? = nil
    ) {

        swipe(
            .right,
            completion: completion
        )
    }

    func reset() {

        unswipedCards = originalCards.map {

            SwipeableCardModel(
                song: $0.song
            )
        }

        swipedCards.removeAll()

        dragState = .zero
    }

    func replaceCards(
        with songs: [Song]
    ) {

        let cards = songs.map {

            SwipeableCardModel(
                song: $0
            )
        }

        originalCards = cards

        unswipedCards = cards

        swipedCards.removeAll()

        dragState = .zero
    }
}
