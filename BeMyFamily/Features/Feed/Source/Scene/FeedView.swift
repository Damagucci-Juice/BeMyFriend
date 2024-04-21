//
//  FeedView.swift
//  BeMyFamily
//
//  Created by Gucci on 4/9/24.
//
import NukeUI
import SwiftUI

struct FeedView: View {
    @EnvironmentObject var reducer: FeedListReducer

    var body: some View {
        ScrollView {
            VStack(spacing: UIConstants.Spacing.interFeedItem) {
                ForEach(reducer.animals) { animal in
                    FeedItemView(animal: animal) {
                        reducer.updateFavorite($0)
                    }
                }
            }
        }
    }
}

#Preview {
    @StateObject var reducer = FeedListReducer()

    return FeedView()
        .environmentObject(reducer)
        .preferredColorScheme(.dark)
}
