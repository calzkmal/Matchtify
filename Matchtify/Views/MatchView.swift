//
//  MatchPageView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 19/06/26.
//

import SwiftUI

struct MatchView: View {
    @StateObject
    private var swipeModel = SwipeableCardsView.Model(
        cards: SongLibrary.songs.map {
            SwipeableCardsView.CardModel(song: $0)
        }
    )
    
    @EnvironmentObject var audioManager: AudioManager
    
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

            // MARK: Header Area
            VStack(spacing: 24) {
                HStack {
                    Text("Match")
                        .font(.largeTitle.bold())
                    
                    Spacer()
                    
                    Image("ProfilePicture")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
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
                    audioManager: audioManager
                ) { model in
                    model.reset()
                }
                
                Button {
                    
                } label: {
                    Text("Haha")
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
