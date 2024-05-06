//
//  DIContainer.swift
//  BeMyFamily
//
//  Created by Gucci on 5/6/24.
//

import Foundation

struct DIContainer {
    static func makeFeedListReducer(_ filterReducer: FilterReducer) -> FeedListReducer {
        return FeedListReducer(service: .init(session: .shared), filterReducer: filterReducer)
    }

    static func makeFilterReducer() -> FilterReducer {
        return FilterReducer(service: .init(session: .shared))
    }

    static func makeProvinceReducer() -> ProvinceReducer {
        return ProvinceReducer(service: .init(session: .shared))
    }
}
