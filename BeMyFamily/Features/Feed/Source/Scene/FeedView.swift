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
                    FeedItemView(animal: animal) { _ in
                        reducer.updateFavorite(animal)
                    }
                }
            }
            .background(GeometryReader { proxy -> Color in
                let maxY = proxy.frame(in: .global).maxY
                let height = proxy.size.height
                // Check if the bottom of the ScrollView is reached
                if maxY < UIScreen.main.bounds.height + 100 && !reducer.isLoading {
                    Task {
                        await reducer.fetchMoreAnimals()
                    }
                }
                return Color.clear
            })
        }
    }
}

#Preview {
    @StateObject var reducer = FeedListReducer()

    return FeedView()
        .environmentObject(reducer)
        .preferredColorScheme(.dark)
}
