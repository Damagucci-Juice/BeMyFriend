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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: UIConstants.Spacing.interFeedItem) {
                    ForEach(reducer.animalDict[reducer.menu, default: []]) { animal in
                        NavigationLink {
                            AnimalDetailView(animal: animal) { _ in
                                reducer.updateFavorite(animal)
                            }
                        } label: {
                            FeedItemView(animal: animal) { _ in
                                reducer.updateFavorite(animal)
                            }
                        }
                    }

                    if reducer.animalDict.isEmpty || reducer.isLoading {
                        ProgressView()
                    }
                }
                // MARK: - Fetch Animals when reached Bottom
                .background(GeometryReader { proxy -> Color in
                    let maxY = proxy.frame(in: .global).maxY
                    let throttle = 150.0
                    let reachedToBottom = maxY < UIConstants.Frame.screenHeight + throttle
                    if reachedToBottom && !reducer.isLoading {
                        // MARK: - 피드라면 example을 호출하고, Filter라면 최근 Filter를 호출
                        if reducer.menu == .feed {
                            Task {
                                await reducer.fetchAnimals()
                            }
                        } else if reducer.menu == .filter {
                            Task {
                                await reducer.fetchAnimals(reducer.selectedFilter)
                            }
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
                            Image(systemName: UIConstants.Image.filter)
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
