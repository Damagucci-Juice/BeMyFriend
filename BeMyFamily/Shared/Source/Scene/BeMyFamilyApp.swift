//
//  BeMyFamilyApp.swift
//  BeMyFamily
//
//  Created by Gucci on 4/9/24.
//

import SwiftUI

@main
struct BeMyFamilyApp: App {
    @StateObject private var reducer = FeedListReducer()
    @StateObject private var filterReducer = FilterReducer()
    @StateObject private var provinceReducer = ProvinceReducer()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(reducer)
                .environmentObject(filterReducer)
                .environmentObject(provinceReducer)
                .preferredColorScheme(.dark)
        }
    }
}
