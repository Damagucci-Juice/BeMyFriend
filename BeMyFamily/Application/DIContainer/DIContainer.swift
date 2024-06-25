//
//  DIContainer.swift
//  BeMyFamily
//
//  Created by Gucci on 5/6/24.
//

import Foundation

struct DIContainer {
    static func makeFeedListReducer(_ viewModel: FilterViewModel, service: SearchService = FamilyService()) -> FeedViewModel {
        return FeedViewModel(service: service, viewModel: viewModel)
    }

    static func makeFilterReducer() -> FilterViewModel {
        return FilterViewModel()
    }

    static func makeProvinceReducer(service: SearchService = FamilyService()) -> ProvinceViewModel {
        return ProvinceViewModel(service: service)
    }
}
