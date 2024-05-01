//
//  FeedListReducer.swift
//  BeMyFamily
//
//  Created by Gucci on 4/19/24.
//
import Foundation

@Observable
final class FeedListReducer: ObservableObject {
    private let service: FriendSearchService

    var menu = FriendMenu.feed
    private(set) var selectedFilter: [AnimalFilter] = [.example]
    private(set) var filterPage = 1

    private(set) var animalDict = [FriendMenu: [Animal]]()
    private(set) var isLoading = false
    private(set) var isLast = false
    private(set) var page = 1
    private var lastFetchTime: Date?

    init(service: FriendSearchService = .init(session: .shared)) {
        self.service = service
        // MARK: - Load Saved Animals from User Defaualts
        self.animalDict[FriendMenu.favorite] = loadSavedAnimals()
    }

    // 이미 실행을 보낸 작업이 있다면 취소하고 새로운 작업을 지시 + 쓰로틀링
    public func fetchAnimalsIfCan(_ filters: [AnimalFilter] = [.example]) async {
        let now = Date()
        let fetchIntervalSec = 0.3
        guard lastFetchTime == nil || now.timeIntervalSince(lastFetchTime!) > fetchIntervalSec else {
            return
        }
        lastFetchTime = now

        Task {
            await fetchMultiKindsAnimals(filters)
        }
     }

    // TODO: - 리펙터링 해야함
    private func fetchMultiKindsAnimals(_ filters: [AnimalFilter]) async {
        guard !isLoading else { return }
            isLoading = true

        // 필터가 이전과 다르면 초기화하고 새로 설정
        resetOccupied(filters)

        // Create a task group to fetch animals for all filters concurrently
        let results = await withTaskGroup(of: (AnimalFilter, [Animal]).self) { group in
            for filter in filters {
                group.addTask {
                    do {
                        let (animals, isLast) = try await self.fetchAnimals(with: filter)
                        return (filter, animals)
                    } catch {
                        return (filter, [])
                    }
                }
            }

            var aggregatedResults = [AnimalFilter: [Animal]]()
            for await (filter, animals) in group {
                if !animals.isEmpty {
                    aggregatedResults[filter, default: []].append(contentsOf: animals)
                }
            }
            return aggregatedResults
        }

        // Update the UI on the main actor thread
        await MainActor.run {

            for (filter, animals) in results {
                animalDict[self.menu, default: []] += syncWithFavorites(animals)
            }
            if self.menu == .filter { filterPage += 1 } else { page += 1 }
            isLoading = false
        }
    }

    /*
    private func performFetch(_ filter: AnimalFilter) async {
        guard !isLoading else { return }
        isLoading = true

        do {
            let (fetchedAnimals, isLastPage) = try await fetchAnimals(with: filter)
            await updateUI(with: fetchedAnimals, isLast: isLastPage)
        } catch {
            await handleError(error)
        }
    }
*/
    private func fetchAnimals(with filter: AnimalFilter) async throws -> ([Animal], Bool) {
        let pageToFetch = self.menu == .feed ? page : filterPage
        let results = try await Actions
            .FetchAnimal(service: service, filter: filter, page: pageToFetch)
            .execute().results
        return (syncWithFavorites(results), results.isEmpty)
    }

    /*
    @MainActor
    private func updateUI(with animals: [Animal], isLast: Bool) {
        animalDict[menu, default: []] += animals
        isLoading = false
        self.isLast = isLast
    }

    @MainActor
    private func handleError(_ error: Error) {
        isLoading = false
        if let httpError = error as? HTTPError,
           case .dataEmtpy(let message) = httpError {
            self.isLast = true
            dump(message)
        } else {
            dump("Error fetching animals at \(#function) in \(#file)")
        }
    }
*/
    // 해당 동물의 isLiked 프로퍼티를 업데이트하고 이를 현재 선택된 menu의 동물 리스트와 업데이트함
    public func updateFavorite(_ animal: Animal) {
        let selectedAnimalList = animalDict[menu, default: []]
        var likedAnimals = animalDict[FriendMenu.favorite, default: []]

        if let heartedAnimal = selectedAnimalList.first(where: {$0 == animal}) {
            if likedAnimals.contains(heartedAnimal) {
                likedAnimals.removeAll(where: { $0 == heartedAnimal })
            } else {
                likedAnimals.append(heartedAnimal)
            }
            animalDict[FriendMenu.favorite] = likedAnimals
            saveFavorites(using: likedAnimals)
        }
        animal.isFavorite.toggle()
    }

    private func loadSavedAnimals() -> [Animal] {
        if let savedAnimals = UserDefaults.standard.object(forKey: Constants.Network.dbPath) as? Data {
            let decoder = JSONDecoder()
            if let loadedAnimals = try? decoder.decode([Animal].self, from: savedAnimals) {
                loadedAnimals.forEach { $0.isFavorite = true }
                return loadedAnimals
            }
        }
        return []
    }

    private func saveFavorites(using animals: [Animal]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(animals) {
            UserDefaults.standard.set(encoded, forKey: Constants.Network.dbPath)
        }
    }

    private func syncWithFavorites(_ animal: [Animal]) -> [Animal] {
        let liked = self.animalDict[FriendMenu.favorite, default: []]
        liked.forEach { likedAnimal in
            if let first = animal.first(where: {$0 == likedAnimal }) {
                first.isFavorite = true
            }
        }
        return animal
    }

    // 기존에 들고 있던 필터와 새로 들어온 필터가 다르면 초기화
    private func resetOccupied(_ filter: [AnimalFilter]) {
        if selectedFilter != filter {
            animalDict[.filter, default: []].removeAll()
            selectedFilter = filter
            filterPage = 1
        }
    }

    public func setMenu(_ menu: FriendMenu) {
        self.menu = menu
    }
}
