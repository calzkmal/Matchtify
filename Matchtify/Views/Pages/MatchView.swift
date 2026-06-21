//
//  MatchPageView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 19/06/26.
//

import SwiftUI

struct MatchView: View {
    @StateObject
    private var swipeModel = SwipeableCardsViewModel(
        cards: SongLibrary.songs.map {
            SwipeableCardsView.CardModel(song: $0)
        }
    )
    
    // AudioManager setup
    @EnvironmentObject var audioManager: AudioManager
    var onNext: () -> Void = {}
    
    // Swipe Button state
    @State private var selectedAction: SwipeAction?
    
    // Popup profile
    @State private var showProfileSheet = false
    
    // Setup Genre List
    @State private var selectedGenre = "All"
    private let genres =
        ["All"] +
        Array(
            Set(SongLibrary.songs.map(\.genre))
        ).sorted()
    
    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()
            
            // MARK: Main Container
            VStack(spacing: 24) {
            
                // MARK: Header Area
                HStack {
                    Text("Match")
                        .font(.largeTitle.bold())
                    
                    Spacer()
                    
                    Button {
                        showProfileSheet = true
                    } label: {
                        Image("ProfilePicture")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                    .sheet(isPresented: $showProfileSheet) {
                        ProfileSheetView()
                            .presentationSizing(.page)
                    }
                }
                
                // MARK: Scrollable Genres
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(genres, id: \.self) { genre in
                            Button {
                                selectedGenre = genre
                                if genre == "All" {
                                    swipeModel.replaceCards(
                                        with: SongLibrary.songs
                                    )
                                } else {
                                    swipeModel.replaceCards(
                                                with: SongLibrary.songs.filter {
                                                    $0.genre == genre
                                                }
                                            )
                                }
                            } label: {
                                Text(genre)
                                    .font(.footnote)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        selectedGenre == genre
                                        ? Color.indigo
                                        : Color(.quaternarySystemFill)
                                    )
                                    .foregroundStyle(
                                        selectedGenre == genre
                                        ? .white
                                        : .secondary
                                    )
                                    .fontWeight(
                                        selectedGenre == genre
                                        ? .bold
                                        : .regular
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
                
                // MARK: Card Area
                SwipeableCardsView(
                    model: swipeModel,
                    audioManager: audioManager,
                    action: { model in
                        model.reset()
                    },
                    onCardSwiped: {
                        selectedAction = nil
                        onNext()
                    },
                    onSwipeDirection: { direction in

                        switch direction {
                        case .left:
                            selectedAction = .dislike

                        case .right:
                            selectedAction = .like

                        case .up:
                            selectedAction = .favorite

                        case .none:
                            break
                        }
                    }
                )
                
                // MARK: Three Buttons
                HStack (spacing: 24) {
                    // Dislike
                    Button {
                        swipeModel.performSwipe(.dislike)
                    } label: {
                        Image(systemName: "hand.thumbsdown")
                            .font(.system(.title, weight: .medium))
                            .foregroundStyle(selectedAction == .dislike
                                ? Color.white
                                : Color.primary
                            )
                            .frame(width: 56, height: 56)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(selectedAction == .dislike
                          ? .indigo
                          : Color.secondary.opacity(0.5)
                    )
                    .clipShape(Circle())
                    
                    // Add to favorite
                    Button {
                        swipeModel.performSwipe(.favorite)
                    } label: {
                        Image(systemName: "heart")
                            .font(.system(.title2, weight: .medium))
                            .foregroundStyle(selectedAction == .favorite
                                ? Color.white
                                : Color.primary
                            )
                            .frame(width: 40, height: 40)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(selectedAction == .favorite
                          ? .indigo
                          : Color.secondary.opacity(0.5)
                    )
                    .clipShape(Circle())
                    
                    // Like
                    Button {
                        swipeModel.performSwipe(.like)
                    } label: {
                        Image(systemName: "hand.thumbsup")
                            .font(.system(.title, weight: .medium))
                            .foregroundStyle(selectedAction == .like
                                ? Color.white
                                : Color.primary
                            )
                            .frame(width: 56, height: 56)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(selectedAction == .like
                          ? .indigo
                          : Color.secondary.opacity(0.5)
                    )
                    .clipShape(Circle())
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    MatchView().environmentObject(AudioManager.preview)
}
