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
                switch menu {
                case .feed, .filter:
                    FeedView()
                        .tabItem { Text(menu.title) }
                        .tag(menu)
                case .favorite:
                    FavoriteView()
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
