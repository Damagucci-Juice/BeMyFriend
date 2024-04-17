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
    struct FetchSido: AsyncAction { }

    struct FetchSigungu: AsyncAction { }

    struct FetchShelter: AsyncAction { }

    struct FetchKind: AsyncAction { }

    struct FetchAnimal: AsyncAction {
        let filter: AnimalFilter
        let page: Int

        func excute(_ service: SearchService) async throws -> PaginatedResponse<Animal> {
            if let fetched = try await service.search(.animal(filteredItem: filter)) {
                do {
                    let animalResponse = try JSONDecoder().decode(AnimalResponse.self, from: fetched)
                    return PaginatedResponse(numbersOfRow: animalResponse.numOfRows,
                                             pageNumber: animalResponse.pageNo,
                                             totalCounts: animalResponse.totalCount,
                                             results: animalResponse.animal)
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
