//
//  FavoriteView.swift
//  BeMyFamily
//
//  Created by Gucci on 4/9/24.
//

import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var reducer: FeedListReducer

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: UIConstants.Spacing.interFeedItem) {
                    ForEach(reducer.liked) { animal in
                        FeedItemView(animal: animal) {
                            reducer.updateFavorite($0)
                        }
                    }
                }
            }
            .navigationTitle(reducer.menu.title)
        }
    }
}

#Preview {
    @StateObject var reducer = FeedListReducer()
    return FavoriteView()
        .environmentObject(reducer)
        .preferredColorScheme(.dark)
}
