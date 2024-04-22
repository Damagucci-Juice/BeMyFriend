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
    // MAYBE: - Movie에서 카테고리를 딕셔너리로 접근하듯이 보여주기
    private(set) var animals: [Animal] = [] {
        didSet {
            syncWithLiked(animals)
        }
    }
    var liked: [Animal] {
        didSet {
            save(using: liked)
        }
    }
    private(set) var isLoading = false
    private(set) var filter = AnimalFilter.example
    private(set) var page = 1
    private var fetchDebounce: DispatchWorkItem?

    init() {
        // MARK: - Load Saved Animals from User Defaualts
        self.liked = {
            if let savedAnimals = UserDefaults.standard.object(forKey: Constants.Network.dbPath) as? Data {
                let decoder = JSONDecoder()
                if let loadedAnimals = try? decoder.decode([Animal].self, from: savedAnimals) {
                    loadedAnimals.forEach { $0.isFavorite = true }
                    return loadedAnimals
                }
            }
            return []
        }()
    }

    // 이미 실행을 보낸 작업이 있다면 취소하고 새로운 작업을 지시
    public func fetchAnimals() async {
        fetchDebounce?.cancel()

        let task = DispatchWorkItem {
            Task { [weak self] in
                await self?.performFetch()
            }
        }
        fetchDebounce = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
     }

    private func performFetch() async {
            guard !isLoading else { return }
            isLoading = true

            do {
                let fetched = try await Actions.FetchAnimal(service: service,
                                                            filter: filter,
                                                            page: page).excute().results
                await MainActor.run {
                    self.animals.append(contentsOf: fetched)
                    self.page += 1
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    print("Error fetching animals: \(error.localizedDescription)")
                }
            }
        }

    public func updateFavorite(_ animal: Animal) {
        if let first = animals.first(where: {$0 == animal}) {
            if liked.contains(first) {
                liked.removeAll(where: { $0 == first })
            } else {
                liked.append(first)
            }
            first.isFavorite.toggle()
        }
    }

    private func save(using animals: [Animal]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(animals) {
            UserDefaults.standard.set(encoded, forKey: Constants.Network.dbPath)
        }
    }

    private func syncWithLiked(_ animal: [Animal]) {
        liked.forEach { likedAnimal in
            if let first = animals.first(where: {$0 == likedAnimal }) {
                first.isFavorite = true
            }
        }
    }
}
