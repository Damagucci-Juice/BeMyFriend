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

        // MARK: - fetch Kind information
        let kindFetchAction =  Actions.FetchKind(service: service)
        Task {
            for upkind in Upkind.allCases { // TODO: - 직렬적으로 하지 말고 병렬적으로 하기 1
                if let fetched = try? await kindFetchAction.excute(upkind.rawValue).results {
                    kind[upkind] = fetched
                }
            }
        }

        // MARK: - fetch sido, sigungu, shelter information
        // TODO: - 장풍 제거 어떻게 할까? 
        Task {
            if let sido = try? await Actions.FetchSido(service: service).excute().results { // TODO: - 직렬적으로 하지 말고 병렬적으로 하기 2
                for eachSido in sido {
                    if let sigungu = try? await Actions.FetchSigungu(service: service).excute(eachSido.id).results {
                        province[eachSido] = sigungu
                        for eachSigungu in sigungu {
                            if let fetchedShelter = try? await Actions.FetchShelter(service: service).excute(eachSido.id, eachSigungu.id).results {
                                shelter[eachSigungu] = fetchedShelter
                            }
                        }
                    }
                }
                self.sido = sido 
            }
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
