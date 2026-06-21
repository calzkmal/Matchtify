//
//  SwipeableCardsViewModel.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 20/06/26.
//

import SwiftUI
import Combine

@MainActor
final class SwipeableCardsViewModel: ObservableObject {

    private var originalCards: [SwipeableCardModel]

    @Published var dragState = CGSize.zero
    @Published var unswipedCards: [SwipeableCardModel]
    @Published var swipedCards: [SwipeableCardModel]

    private let dismissDistance: CGFloat = 1000

    var allowsSwipeUp = true
    
    init(cards: [SwipeableCardModel]) {

        var cards = cards

        if cards.count == 1,
           let card = cards.first {

            cards.append(
                SwipeableCardModel(song: card.song)
            )
        }

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

        var card = unswipedCards.removeFirst()

        card.swipeDirection = .none

        unswipedCards.append(card)
    }

    func swipe(
        _ direction: SwipeDirection,
        completion: (() -> Void)? = nil
    ) {
        guard !unswipedCards.isEmpty else {
            return
        }

        updateTopCardSwipeDirection(direction)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {

            withAnimation(.easeOut(duration: 0.4)) {

                switch direction {

                case .right:
                    self.dragState = CGSize(
                        width: self.dismissDistance,
                        height: 0
                    )

                case .left:
                    self.dragState = CGSize(
                        width: -self.dismissDistance,
                        height: 0
                    )

                case .up:
                    self.dragState = CGSize(
                        width: 0,
                        height: -self.dismissDistance
                    )

                case .none:
                    self.dragState = .zero
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {

                self.removeTopCard()

                self.dragState = .zero

                completion?()
            }
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

    func swipeUp(
        completion: (() -> Void)? = nil
    ) {
        swipe(
            .up,
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

    func replaceCards(with songs: [Song]) {

        var cards = songs.map {
            SwipeableCardModel(song: $0)
        }

        // Pastikan minimal ada dua card
        if cards.count == 1,
           let song = songs.first {

            cards.append(
                SwipeableCardModel(song: song)
            )
        }

        originalCards = cards
        unswipedCards = cards
        swipedCards.removeAll()
        dragState = .zero
    }
}
