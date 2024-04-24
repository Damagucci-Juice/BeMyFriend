//
//  TabControlView.swift
//  BeMyFamily
//
//  Created by Gucci on 4/19/24.
//

import SwiftUI

struct TabControlView: View {
    @EnvironmentObject var reducer: FeedListReducer

    var body: some View {
        TabView(selection: $reducer.menu) {
            ForEach(FriendMenu.allCases, id: \.self) { menu in
                // MARK: - FilterView, FavoriteView는 FeedView 안에 중첩 구현
                if menu != .filter {
                    FeedView()
                        .tabItem { Text(menu.title) }
                        .tag(menu)
                }
            }
        }
    }
}

#Preview {
    @StateObject var reducer = FeedListReducer()

    return TabControlView()
        .environmentObject(reducer)
        .preferredColorScheme(.dark)
}
