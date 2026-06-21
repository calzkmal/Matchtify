//
//  SwipeableCardView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 20/06/26.
//

import SwiftUI
import Combine
import Foundation

struct SwipeableCardsView: View {
    typealias ViewModel = SwipeableCardsViewModel
    typealias CardModel = SwipeableCardModel

    let swipeThreshold: CGFloat = 100
    let rotationFactor: Double = 35
    let stackedCardOffset: CGFloat = 10

    @ObservedObject
    var model: SwipeableCardsViewModel

    @ObservedObject
    var audioManager: AudioManager

    var action: (SwipeableCardsViewModel) -> Void
    var onCardSwiped: (() -> Void)? = nil

    var allowsSwipeUp: Bool = true
    
    var onSwipeDirection: ((SwipeDirection) -> Void)? = nil
    
    var body: some View {
        Group {

            if model.unswipedCards.isEmpty &&
                model.swipedCards.isEmpty {

                EmptyCardsView()

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
