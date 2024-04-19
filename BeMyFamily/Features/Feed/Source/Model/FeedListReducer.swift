//
//  FeedListReducer.swift
//  BeMyFamily
//
//  Created by Gucci on 4/19/24.
//

import Foundation

@Observable
final class FeedListReducer: ObservableObject {
    private let service = FriendSearchService()
    // TODO: - Movie에서 카테고리를 딕셔너리로 접근하듯이 보여주기
    private(set) var animals: [Animal] = []
    var liked: [Animal] {
        animals.filter { animal in animal.isFavorite }
    }
    private(set) var filter = AnimalFilter.example
    private(set) var page = 1

    public func fetchAnimal() async {
        do {
            let fetched = try await Actions.FetchAnimal(service: service, filter: filter, page: page).excute().results
            await MainActor.run {
                self.animals.append(contentsOf: fetched)
            }
        } catch {
            dump(error.localizedDescription)
        }
    }

    // TODO: - JSON으로 저장해야할까? 아니면 User Default 정도면 충분할까?
    public func updateFavorite(_ animal: Animal) {
        let selectedIndex = animals.firstIndex { target in
            target == animal
        }
        guard let selectedIndex else { return }
        animals[selectedIndex].isFavorite.toggle()
    }
}
