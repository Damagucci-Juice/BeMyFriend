//
//  Actions.swift
//  BeMyFamily
//
//  Created by Gucci on 4/13/24.
//
//
import Foundation
import Combine

struct Actions {
    struct FetchSido: AsyncAction {
        let service: FriendSearchService

        public func execute() async throws -> PaginatedResponse<Sido> {
            if let fetched = try await service.search(.sido) {
                do {
                    let sidoResponse = try JSONDecoder().decode(PaginatedAPIResponse<Sido>.self, from: fetched)
                    return PaginatedResponse(numbersOfRow: sidoResponse.numOfRows,
                                             pageNumber: sidoResponse.pageNo,
                                             totalCounts: sidoResponse.totalCount,
                                             results: sidoResponse.items)
                } catch let error {
                    dump(fetched.prettyPrintedJSONString ?? "")
                    throw error
                }
            }
            throw HTTPError.invalidResponse(HttpStatusCode.ClientError.notFoundError)
        }
    }

    struct FetchSigungu: AsyncAction {
        let service: FriendSearchService

        private func execute(_ sidoCode: String) async throws -> Response<Sigungu> {
            if let fetched = try await service.search(.sigungu(sido: sidoCode)) {
                do {
                    let sigunguResponse = try JSONDecoder().decode(APIResponse<Sigungu>.self, from: fetched)
                    return Response(results: sigunguResponse.items)
                } catch let error {
                    dump(fetched.prettyPrintedJSONString ?? "")
                    throw error
                }
            }
            throw HTTPError.invalidResponse(HttpStatusCode.ClientError.notFoundError)
        }

        public func execute(by sidos: [Sido]) async -> [Sido: [Sigungu]] {
            await withTaskGroup(of: (Sido, [Sigungu]).self) { group in
                for sido in sidos {
                    group.addTask {
                        do {
                            let fetchedSigungu = try await execute(sido.id).results
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
    }

    struct FetchShelter: AsyncAction {
        let service: FriendSearchService

        private func execute(_ sidoCode: String, _ sigunguCode: String) async throws -> Response<Shelter> {
            if let fetched = try await service.search(.shelter(sido: sidoCode, sigungu: sigunguCode)) {
                do {
                    let shelterResponse = try JSONDecoder().decode(APIResponse<Shelter>.self, from: fetched)
                    return Response(results: shelterResponse.items)
                } catch let error {
                    dump(fetched.prettyPrintedJSONString ?? "")
                    throw error
                }
            }
            throw HTTPError.invalidResponse(HttpStatusCode.ClientError.notFoundError)
        }

        public func execute(by province: [Sido: [Sigungu]]) async -> [Sigungu: [Shelter]] {
            await withTaskGroup(of: (Sigungu, [Shelter]).self) { group in
                for (sido, sigungus) in province {
                    for eachSigungu in sigungus {
                        group.addTask {
                            do {
                                let fetchedShelter = try await execute(sido.id, eachSigungu.id).results
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
    }

    struct FetchKind: AsyncAction {
        let service: FriendSearchService

        private func execute(_ upkindCode: String) async throws -> Response<Kind> {
            if let fetched = try await service.search(.kind(upkind: upkindCode)) {
                do {
                    let sigunguResponse = try JSONDecoder().decode(APIResponse<Kind>.self, from: fetched)
                    return Response(results: sigunguResponse.items)
                } catch let error {
                    dump(fetched.prettyPrintedJSONString ?? "")
                    throw error
                }
            }
            throw HTTPError.invalidResponse(HttpStatusCode.ClientError.notFoundError)
        }

        public func execute(by upkinds: [Upkind]) async throws -> [Upkind: [Kind]] {
            try await withThrowingTaskGroup(of: (Upkind, [Kind]).self) { group in
                for upkind in upkinds {
                    group.addTask {
                        let fetchedKind = try await execute(upkind.id).results
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
    }

    struct FetchAnimal: AsyncAction {
        let service: FriendSearchService
        let filter: AnimalFilter
        let page: Int

        public func execute() async throws -> PaginatedResponse<Animal> {
            guard let fetched = try await service.search(.animal(filteredItem: filter, page: page)) else {
                throw HTTPError.invalidResponse(HttpStatusCode.ClientError.notFoundError)
            }
            do {
                let animalResponse = try JSONDecoder().decode(PaginatedAPIResponse<Animal>.self, from: fetched)
                return PaginatedResponse(numbersOfRow: animalResponse.numOfRows,
                                         pageNumber: animalResponse.pageNo,
                                         totalCounts: animalResponse.totalCount,
                                         results: animalResponse.items)
            } catch let error {
                dump(fetched.prettyPrintedJSONString ?? "")
                // MARK: - 데이터가 없어서 PaginatedAPIResponse.items 항목을 생성하지 못해 디코딩 에러가 발생함
                throw HTTPError.dataEmtpy(error.localizedDescription)
            }
        }
    }
}

protocol Action { }
protocol AsyncAction: Action { }
