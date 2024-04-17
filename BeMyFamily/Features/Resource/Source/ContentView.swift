//
//  ContentView.swift
//  BeMyFamily
//
//  Created by Gucci on 4/9/24.
//
import Combine
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("Feed")
                }

            FavoriteView()
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Favorite")
                }
        }
    }
}

#Preview {
    ContentView()
}
