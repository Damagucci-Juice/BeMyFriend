//
//  TabControlView.swift
//  BeMyFamily
//
//  Created by Gucci on 4/19/24.
//

import SwiftUI

struct TabControlView: View {
    @EnvironmentObject var reducer: FeedListReducer
    @EnvironmentObject var filterReducer: FilterReducer

    var body: some View {
        TabView(selection: $reducer.menu) {
            ForEach(FriendMenu.allCases, id: \.self) { menu in
                // MARK: - FilterView, FavoriteView는 FeedView 안에 중첩 구현
                if menu != .filter {
                    FeedView()
                        .tabItem { Label(menu.title, systemImage: menu.image) }
                        .tag(
                            currentMenu(menu)
                        )
                }
            }
        }
    }
}

extension TabControlView {
    // filtering list가 진행 중일 때는 현재 menu가 .feed 더라도 .filter를 반환하도록 설정
    private func currentMenu(_ menu: FriendMenu) -> FriendMenu {
        if menu == .feed {
            if filterReducer.onProcessing {
                return .filter
            } else {
                return .feed
            }
        }
        return menu
    }
}

#Preview {
    @StateObject var reducer = DIContainer.makeFeedListReducer(DIContainer.makeFilterReducer())

    return TabControlView()
        .environmentObject(reducer)
        .preferredColorScheme(.dark)
}
