//
//  DIContainer.swift
//  BeMyFamily
//
//  Created by Gucci on 5/6/24.
//

import Foundation

struct DIContainer {
    static func makeFeedListReducer(_ filterReducer: FilterReducer, service: SearchService = FamilyService()) -> FeedViewModel {
        return FeedViewModel(service: service, filterReducer: filterReducer)
    }

    static func makeFilterReducer() -> FilterReducer {
        return FilterReducer()
    }

    static func makeProvinceReducer(service: SearchService = FamilyService()) -> ProvinceReducer {
        return ProvinceReducer(service: service)
    }
}
