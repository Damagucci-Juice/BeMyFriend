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

                if reducer.animals.isEmpty || reducer.isLoading {
                    ProgressView()
                }
            }
            // MARK: - Fetch Animals when reached Bottom
            .background(GeometryReader { proxy -> Color in
                let maxY = proxy.frame(in: .global).maxY
                let reachedToBottom = maxY < UIConstants.Frame.screenHeight + 100
                if reachedToBottom && !reducer.isLoading {
                    Task {
                        await reducer.fetchAnimals()
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
