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
        self.kinds = []
    }

    var beginDate = Date.now.addingTimeInterval(UIConstants.Date.aDayBefore*10) // 10일 전
    var endDate = Date()
    var upkind: Upkind?
    var kinds: [Kind]
    var sido: Sido?
    var sigungu: Sigungu?
    var shelter: Shelter?
    var state = ProcessState.all
    var neutral: Neutralization?

    func makeFilter() -> [AnimalFilter] {
        let baseFilter = AnimalFilter(
            beginDate: beginDate,
            endDate: endDate,
            upkind: upkind?.id,
            kind: nil,
            sido: sido?.id,
            sigungu: sigungu?.id,
            shelterNumber: shelter?.id,
            processState: state.id,
            neutralizationState: neutral?.id
        )

        if kinds.isEmpty {
            return [baseFilter]
        } else {
            return kinds.map { kind in
                var filter = baseFilter
                filter.kind = kind
                return filter
            }
        }
    }


    func reset() {
        beginDate = Date.now.addingTimeInterval(UIConstants.Date.aDayBefore*10)
        endDate = Date()
        upkind = .none
        kinds.removeAll()
        sido = .none
        sigungu = .none
        shelter = .none
        state = .all
        neutral = .none
    }
}
