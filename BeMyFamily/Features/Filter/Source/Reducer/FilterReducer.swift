//
//  FilterReducer.swift
//  BeMyFamily
//
//  Created by Gucci on 4/26/24.
//

import Foundation

@Observable
final class FilterReducer: ObservableObject {
    private let service: FriendSearchService
    init(service: FriendSearchService = .init(session: .shared)) {
        self.service = service
    }

    var beginDate = Date.now.addingTimeInterval(UIConstants.Date.aDayBefore*10) // 10일 전
    var endDate = Date()
    var upkind: Upkind?
    var kind: Kind?
    var sido: Sido?
    var sigungu: Sigungu?
    var shelter: Shelter?
    var state = ProcessState.all
    var neutral: Neutralization?

    func makeFilter() -> AnimalFilter {
        return AnimalFilter(beginDate: beginDate,
                            endDate: endDate,
                            upkind: upkind?.id,
                            kind: kind?.id,
                            sido: sido?.id,
                            sigungu: sigungu?.id,
                            shelterNumber: shelter?.id,
                            processState: state.id,
                            neutralizationState: neutral?.id)
    }

    func reset() {
        beginDate = Date.now.addingTimeInterval(UIConstants.Date.aDayBefore*10)
        endDate = Date()
        upkind = .none
        kind = .none
        sido = .none
        sigungu = .none
        shelter = .none
        state = .all
        neutral = .none
    }
}
