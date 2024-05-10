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
        let service: SearchService

        public func execute() async throws -> PaginatedResponse<Sido> {
            do {
                let fetched = try await service.search(.sido)
                let sidoResponse = try JSONDecoder().decode(PaginatedAPIResponse<Sido>.self, from: fetched)
                return PaginatedResponse(numbersOfRow: sidoResponse.numOfRows,
                                         pageNumber: sidoResponse.pageNo,
                                         totalCounts: sidoResponse.totalCount,
                                         results: sidoResponse.items)
            } catch let error {
                throw error
            }
        }
    }

    struct FetchSigungu: AsyncAction {
        let service: SearchService

        private func execute(_ sidoCode: String) async throws -> Response<Sigungu> {
            do {
                let fetched = try await service.search(.sigungu(sido: sidoCode))
                let sigunguResponse = try JSONDecoder().decode(APIResponse<Sigungu>.self, from: fetched)
                return Response(results: sigunguResponse.items)
            } catch let error {
                throw error
            }
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
        let service: SearchService

        private func execute(_ sidoCode: String, _ sigunguCode: String) async throws -> [Shelter] {
            do {
                let fetched = try await service.search(.shelter(sido: sidoCode, sigungu: sigunguCode))
                return try SetShelter(data: fetched).excute().results
            } catch let error {
                throw error
            }
        }

        public func execute(by province: [Sido: [Sigungu]]) async -> [Sigungu: [Shelter]] {
            await withTaskGroup(of: (Sigungu, [Shelter]).self) { group in
                for (sido, sigungus) in province {
                    for eachSigungu in sigungus {
                        group.addTask {
                            do {
                                let fetchedShelter = try await execute(sido.id, eachSigungu.id)
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

    struct SetShelter: Action {
        let data: Data

        public func excute() throws -> Response<Shelter> {
            let shelterResponse = try JSONDecoder().decode(APIResponse<Shelter>.self, from: data)
            return Response(results: shelterResponse.items)
        }
    }

    struct FetchKind: AsyncAction {
        let service: SearchService

        private func execute(_ upkindCode: String) async throws -> [Kind] {
            do {
                let fetched = try await service.search(.kind(upkind: upkindCode))
                return try SetKind(data: fetched).excute().results
            } catch {
                throw error
            }
        }

        public func execute(by upkinds: [Upkind]) async throws -> [Upkind: [Kind]] {
            try await withThrowingTaskGroup(of: (Upkind, [Kind]).self) { group in
                for upkind in upkinds {
                    group.addTask {
                        let fetchedKind = try await execute(upkind.id)
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

    struct SetKind: Action {
        let data: Data

        func excute() throws -> Response<Kind> {
            do {
                let sigunguResponse = try JSONDecoder().decode(APIResponse<Kind>.self, from: data)
                return Response(results: sigunguResponse.items)
            } catch {
                throw error
            }
        }
    }

    struct FetchAnimal: AsyncAction {
        let service: SearchService
        let filter: AnimalFilter
        let page: Int

        public func execute() async throws -> [Animal] {
            do {
                let fetched = try await service.search(.animal(filteredItem: filter, page: page))
                return try SetAnimal(data: fetched).excute().results
            } catch let error {
                throw error
            }
        }
    }

    struct SetAnimal: Action {
        let data: Data

        public func excute() throws -> PaginatedResponse<Animal> {
            do {
                let animalResponse = try JSONDecoder().decode(PaginatedAPIResponse<Animal>.self, from: data)
                return PaginatedResponse(numbersOfRow: animalResponse.numOfRows,
                                         pageNumber: animalResponse.pageNo,
                                         totalCounts: animalResponse.totalCount,
                                         results: animalResponse.items)
            } catch {
                throw error
            }
        }
    }
}

protocol Action { }
protocol AsyncAction: Action { }
