//
//  MainTabView.swift
//  Matchtify
//
//  Created by Calzy Akmal Indyramdhani on 21/06/26.
//

import SwiftUI

struct MainTabView: View {

    @State private var searchText = ""

    var body: some View {
        TabView {

            Tab("Match", systemImage: "sparkles") {
                MatchView()
                    .environmentObject(AudioManager.preview)
            }

            Tab("Explore", systemImage: "safari") {
                ExploreView()
            }

            Tab("Library", systemImage: "music.note.square.stack") {
                LibraryView()
            }

            // Search tab terpisah di kanan
            Tab("Search",
                systemImage: "magnifyingglass",
                role: .search
            ) {
                NavigationStack {
                    Text("Search View")
                        .navigationTitle("Search")
                }
            }
        }
        .searchable(text: $searchText)
        .tint(.indigo)
    }
}

#Preview {
    MainTabView()
}
