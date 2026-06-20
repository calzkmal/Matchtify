//
//  SwipeableCardView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 20/06/26.
//

import SwiftUI
import Combine

struct SwipeableCardsView: View {

    enum SwipeDirection {
        case left
        case right
        case none
    }

    struct CardModel: Identifiable, Equatable {
        let id = UUID()
        let song: Song
        var swipeDirection: SwipeDirection = .none
    }

    @MainActor
    final class Model: ObservableObject {

        private var originalCards: [CardModel]

        @Published var dragState = CGSize.zero
        @Published var unswipedCards: [CardModel]
        @Published var swipedCards: [CardModel]

        private let dismissDistance: CGFloat = 1000

        init(cards: [CardModel]) {
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
                CardModel(song: $0.song)
            }

            swipedCards.removeAll()
            dragState = .zero
        }

        func replaceCards(
            with songs: [Song]
        ) {

            let cards = songs.map {
                CardModel(song: $0)
            }

            originalCards = cards
            unswipedCards = cards
            swipedCards.removeAll()
            dragState = .zero
        }
    }

    @ObservedObject var model: Model
    @ObservedObject var audioManager: AudioManager

    private let swipeThreshold: CGFloat = 100
    private let rotationFactor: Double = 35

    var action: (Model) -> Void
    var onCardSwiped: (() -> Void)? = nil

    var body: some View {

        GeometryReader { geometry in

            if model.unswipedCards.isEmpty &&
                model.swipedCards.isEmpty {

                emptyCardsView
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )

            } else if model.unswipedCards.isEmpty {

                swipingCompletionView
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )

            } else {

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
                            abs(model.dragState.width) / swipeThreshold,
                            1
                        )

                        CardView(
                            song: card.song,
                            isPlaying: audioManager.isPlaying,
                            onPlayTapped: {
                                audioManager.togglePlayback()
                            }
                        )
                        .scaleEffect(
                            isTop ? 1 :
                            isSecond ? 0.95 : 0.9
                        )
                        .opacity(
                            isTop ? 1 : revealProgress
                        )
                        .offset(
                            x: isTop ? model.dragState.width : 0,
                            y: isTop ? 0 :
                            isSecond ? 10 : 20
                        )
                        .rotationEffect(
                            .degrees(
                                isTop
                                ? Double(model.dragState.width)
                                    / rotationFactor
                                : 0
                            )
                        )
                        .gesture(
                            isTop
                            ? DragGesture()

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
                                            completion:
                                                onCardSwiped
                                        )

                                    } else {

                                        withAnimation(
                                            .spring(
                                                response: 0.4,
                                                dampingFraction: 0.8
                                            )
                                        ) {

                                            model.dragState =
                                                .zero
                                        }
                                    }
                                }
                            : nil
                        )
                    }
                }
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
            }
        }

        .onAppear {

            guard let song =
                model.unswipedCards.first?.song
            else {
                return
            }

            audioManager.loadSong(song)
        }

        .onChange(
            of: model.unswipedCards.first?.id
        ) { _, _ in

            guard let song =
                model.unswipedCards.first?.song
            else {
                return
            }

            audioManager.loadSong(song)
        }
    }

    private var emptyCardsView: some View {

        VStack {

            Text("No Cards")
                .font(.title)
                .foregroundStyle(.secondary)
        }
    }

    private var swipingCompletionView: some View {

        VStack(spacing: 20) {

            Text("Finished Swiping")
                .font(.title)

            Button {

                action(model)

            } label: {

                Text("Reset")
                    .font(.headline)
                    .frame(
                        width: 200,
                        height: 50
                    )
                    .background(
                        Color.accentColor
                    )
                    .foregroundStyle(.white)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 12
                        )
                    )
            }
        }
    }
}
