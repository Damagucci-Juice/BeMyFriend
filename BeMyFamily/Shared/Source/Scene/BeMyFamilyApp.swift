//
//  BeMyFamilyApp.swift
//  BeMyFamily
//
//  Created by Gucci on 4/9/24.
//

import SwiftUI

@main
struct BeMyFamilyApp: App {
    @StateObject private var filterReducer: FilterReducer
    @StateObject private var reducer: FeedViewModel
    @StateObject private var provinceReducer: ProvinceViewModel

    init() {
        let filterReducer = DIContainer.makeFilterReducer()
        _filterReducer = StateObject(wrappedValue: filterReducer)
        _reducer = StateObject(wrappedValue: DIContainer.makeFeedListReducer(filterReducer))
        _provinceReducer = StateObject(wrappedValue: DIContainer.makeProvinceReducer())
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(filterReducer)
                .environmentObject(provinceReducer)
                .environmentObject(reducer)
                .preferredColorScheme(.dark)
        }
    }
}
