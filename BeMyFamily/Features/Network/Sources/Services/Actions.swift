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

        func excute() async throws -> PaginatedResponse<Sido> {
            if let fetched = try await service.search(.sido) {
                do {
                    let sidoResponse = try JSONDecoder().decode(APIResponse<Sido>.self, from: fetched)
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

    struct FetchSigungu: AsyncAction { }

    struct FetchShelter: AsyncAction { }

    struct FetchKind: AsyncAction { }

    struct FetchAnimal: AsyncAction {
        let service: FriendSearchService
        let filter: AnimalFilter
        let page: Int

        func excute() async throws -> PaginatedResponse<Animal> {
            if let fetched = try await service.search(.animal(filteredItem: filter)) {
                do {
                    let animalResponse = try JSONDecoder().decode(APIResponse<Animal>.self, from: fetched)
                    return PaginatedResponse(numbersOfRow: animalResponse.numOfRows,
                                             pageNumber: animalResponse.pageNo,
                                             totalCounts: animalResponse.totalCount,
                                             results: animalResponse.items)
                } catch let error {
                    dump(fetched.prettyPrintedJSONString ?? "")
                    throw error
                }
            }
            throw HTTPError.invalidResponse(HttpStatusCode.ClientError.notFoundError)
        }
    }
}

protocol Action { }
protocol AsyncAction: Action { }
