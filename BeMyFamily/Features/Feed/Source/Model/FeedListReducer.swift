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
     var menu = FriendMenu.feed
    private(set) var selectedFilter: AnimalFilter?
    private(set) var filtered = [AnimalFilter: [Animal]]()
    private(set) var kind = [Upkind: [Kind]]()
    private(set) var sido = [Sido]()    // TODO: - 1안, Dictionary로 빼기, 2안 Sido안에 Sigungu, Shelter를 포함한 새로운 Entity를 제작
    private(set) var province = [Sido: [Sigungu]]()
    private(set) var shelter = [Sigungu: [Shelter]]()
    private(set) var isLoading = false
    private(set) var page = 1
    private var lastFetchTime: Date?
    var selectedAnimals: [Animal] {
        if menu == .filter, let selectedFilter = selectedFilter {
            return filtered[selectedFilter, default: animals]
        }
        return animals
    }

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

        Task {
            do {
                self.kind = try await fetchKind(by: Upkind.allCases)
                self.sido = try await Actions.FetchSido(service: service).excute().results
                self.province = try await fetchSigungu(by: sido)
                self.shelter = try await fetchShelter(by: province)
            } catch {
                print("failed at fetching kind using by upkind")
            }
        }
    }
    
    // MARK: - swift concurrency with parrall
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

    private func fetchSigungu(by sidos: [Sido]) async throws -> [Sido: [Sigungu]] {
        try await withThrowingTaskGroup(of: (Sido, [Sigungu]).self) { group in
            for sido in sidos {
                group.addTask {
                    let fetchedSigungu = try await Actions.FetchSigungu(service: self.service).excute(sido.id).results
                    return (sido, fetchedSigungu)
                }
            }

            var sigungus = [Sido: [Sigungu]]()
            for try await (sido, fetchedSigungu) in group {
                sigungus[sido] = fetchedSigungu
            }
            return sigungus
        }
    }

    private func fetchShelter(by province: [Sido: [Sigungu]]) async throws -> [Sigungu: [Shelter]] {
        try await withThrowingTaskGroup(of: (Sigungu, [Shelter]).self) { group in
            for (sido, sigungus) in province {
                for eachSigungu in sigungus {
                    group.addTask {
                        let fetchedShelter = try await Actions.FetchShelter(service: self.service).excute(sido.id, eachSigungu.id).results
                        return (eachSigungu, fetchedShelter)
                    }
                }
            }
            var shelters = [Sigungu: [Shelter]]()
            for try await (eachSigungu, fetchedShelter) in group {
                shelters[eachSigungu] = fetchedShelter
            }
            return shelters
        }
    }

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

    private func performFetch(_ filter: AnimalFilter?) async {
            guard !isLoading else { return }
            isLoading = true

            do {
                if let filter {
                    let fetchedFiltered = try await Actions.FetchAnimal(service: service,
                                                                filter: filter,
                                                                page: 1).excute().results
                    await MainActor.run {
                        self.page += 1
                        setMenu(by: filter)
                        self.filtered[filter, default: []] += fetchedFiltered
                        self.isLoading = false
                    }
                } else {
                    let fetched = try await Actions.FetchAnimal(service: service,
                                                                filter: .example,
                                                                page: page).excute().results
                    await MainActor.run {
                        self.animals.append(contentsOf: fetched)
                        self.page += 1
                        self.isLoading = false
                    }
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

    private func setMenu(by filter: AnimalFilter) {
        self.menu = .filter
        self.selectedFilter = filter
    }
}
