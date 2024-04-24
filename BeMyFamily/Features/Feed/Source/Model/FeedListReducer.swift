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

    // MARK: - before progress
    private(set) var kind = [Upkind: [Kind]]()
    private(set) var sido = [Sido]()    // MAYBE: - 1안, Dictionary로 빼기, 2안 Sido안에 Sigungu, Shelter를 포함한 새로운 Entity를 제작
    private(set) var province = [Sido: [Sigungu]]()
    private(set) var shelter = [Sigungu: [Shelter]]()

    // MARK: - in progress
    var menu = FriendMenu.feed
    private(set) var selectedFilter: AnimalFilter?
    private(set) var animalDict = [FriendMenu: [Animal]]()
    private(set) var isLoading = false
    private(set) var page = 1
    private(set) var filterPage = 1
    private var lastFetchTime: Date?

    init() {
        // MARK: - Load Saved Animals from User Defaualts
        self.animalDict[FriendMenu.favorite] = loadSavedAnimals()

        Task {
            do {
                self.kind = try await fetchKind(by: Upkind.allCases)
                self.sido = try await Actions.FetchSido(service: service).excute().results
                self.province = await fetchSigungu(by: sido)
                self.shelter = await fetchShelter(by: province)
            } catch {
                print("failed at fetching kind using by upkind")
            }
        }
    }
    // TODO: - 이 흐름이 Actions에 가야하지 않을까...?
    // MARK: - swift concurrency with parrall Begin
    private func fetchKind(by upkinds: [Upkind]) async throws -> [Upkind: [Kind]] {
        try await withThrowingTaskGroup(of: (Upkind, [Kind]).self) { group in
            for upkind in upkinds {
                group.addTask {
                    let fetchedKind = try await Actions.FetchKind(service: self.service).excute(upkind.id).results
                    return (upkind, fetchedKind)
                }
            }
            var kinds = [Upkind: [Kind]]()

            for try await (upkind, fetchedKind) in group {
                kinds[upkind] = fetchedKind
            }

            return kinds
        }
    }

    private func fetchSigungu(by sidos: [Sido]) async -> [Sido: [Sigungu]] {
        await withTaskGroup(of: (Sido, [Sigungu]).self) { group in
            for sido in sidos {
                group.addTask {
                    do {
                        // swiftlint: disable line_length
                        let fetchedSigungu = try await Actions.FetchSigungu(service: self.service).excute(sido.id).results
                        // swiftlint: enable line_length
                        return (sido, fetchedSigungu)
                    } catch {
                        NSLog("Error fetching Sigungu for \(sido.id): \(error)")
                        return (sido, [])
                    }
                }
            }

            var sigungus = [Sido: [Sigungu]]()
            for await (eachSido, fetchedSigungu) in group {
                sigungus[eachSido] = fetchedSigungu
            }
            return sigungus
        }
    }

    private func fetchShelter(by province: [Sido: [Sigungu]]) async -> [Sigungu: [Shelter]] {
        await withTaskGroup(of: (Sigungu, [Shelter]).self) { group in
            for (sido, sigungus) in province {
                for eachSigungu in sigungus {
                    group.addTask {
                        do {
                            // swiftlint: disable line_length
                            let fetchedShelter = try await Actions.FetchShelter(service: self.service).excute(sido.id, eachSigungu.id).results
                            // swiftlint: enable line_length
                            return (eachSigungu, fetchedShelter)
                        } catch {
                            NSLog("Error fetching Shelter for \(sido.id): \(error)")
                            return (eachSigungu, [])
                        }
                    }
                }
            }
            var shelters = [Sigungu: [Shelter]]()
            for await (eachSigungu, fetchedShelter) in group {
                shelters[eachSigungu] = fetchedShelter
            }
            return shelters
        }
    }
    // MARK: - swift concurrency with parrall End

    // 이미 실행을 보낸 작업이 있다면 취소하고 새로운 작업을 지시
    public func fetchAnimals(_ filter: AnimalFilter? = nil) async {
        let now = Date()
        let fetchIntervalSec = 0.3
        guard lastFetchTime == nil || now.timeIntervalSince(lastFetchTime!) > fetchIntervalSec else {
            return
        }
        lastFetchTime = now

        Task {
            await performFetch(filter)
        }
     }

    @MainActor
    private func performFetch(_ filter: AnimalFilter?) async {
        guard !isLoading else { return }
        isLoading = true

        let fetchedAnimals: [Animal]
        do {
            // TODO: - results 값이 비었다면 여기서 처리해야하나?
            if let filter {
                resetOccupied(with: filter)
                fetchedAnimals = try await Actions.FetchAnimal(service: service,
                                                                    filter: filter,
                                                                    page: filterPage).excute().results
                filterPage += 1
            } else {
                fetchedAnimals = try await Actions.FetchAnimal(service: service,
                                                            filter: .example,
                                                            page: page).excute().results
                page += 1
            }

            let fetchedAnimalsSyncdByFavorite =  syncWithFavorites(fetchedAnimals)
            animalDict[menu, default: []] += fetchedAnimalsSyncdByFavorite
            isLoading = false
        } catch {
            await MainActor.run {
                self.isLoading = false
                print("Error fetching animals: \(error.localizedDescription)")
            }
        }
    }

    public func updateFavorite(_ animal: Animal) {
        let selectedAnimalList = animalDict[menu, default: []]
        var likedAnimals = animalDict[FriendMenu.favorite, default: []]

        if let heartedAnimal = selectedAnimalList.first(where: {$0 == animal}) {
            if likedAnimals.contains(heartedAnimal) {
                likedAnimals.removeAll(where: { $0 == heartedAnimal })
            } else {
                likedAnimals.append(heartedAnimal)
            }
            heartedAnimal.isFavorite.toggle()
            animalDict[FriendMenu.favorite] = likedAnimals
            saveFavorites(using: likedAnimals)
        }
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
    private func resetOccupied(with filter: AnimalFilter) {
        if self.selectedFilter != filter {
            self.animalDict[self.menu, default: []].removeAll()
            self.selectedFilter = filter
        }
    }

    public func setMenu(_ menu: FriendMenu) {
        self.menu = menu
    }
}
