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
    @State private var showfilter = false
    private var selectedAnimals: [Animal] {
        if reducer.menu == .filter, let selectedFilter = reducer.selectedFilter {
            return reducer.filtered[selectedFilter, default: reducer.animals]
        }
        return reducer.animals
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: UIConstants.Spacing.interFeedItem) {
                    ForEach(selectedAnimals) { animal in
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
                    let throttle = 150.0
                    let reachedToBottom = maxY < UIConstants.Frame.screenHeight + throttle
                    if reachedToBottom && !reducer.isLoading {
                        Task {
                            await reducer.fetchAnimals()
                        }
                    }
                    return Color.clear
                })
                .fullScreenCover(isPresented: $showfilter) {
                    AnimalFilterForm()
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showfilter.toggle()
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
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

    return FeedView()
        .environmentObject(reducer)
        .preferredColorScheme(.dark)
}
