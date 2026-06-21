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

    private let swipeThreshold: CGFloat = 100
    private let rotationFactor: Double = 35
    private let stackedCardOffset: CGFloat = 10

    @ObservedObject
    var model: SwipeableCardsModel

    @ObservedObject
    var audioManager: AudioManager

    var action: (SwipeableCardsModel) -> Void
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
