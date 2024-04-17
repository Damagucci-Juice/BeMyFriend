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

        func excute(_ service: SearchService) -> AnyPublisher<PaginatedResponse<Animal>, Error> {
            let animalPublisher = service.search(.animal(filteredItem: filter))
            return animalPublisher
                .decode(
                    type: AnimalResponse.self,
                    decoder: JSONDecoder()
                )
                .map {
                    PaginatedResponse(numbersOfRow: $0.numOfRows,
                                      pageNumber: $0.pageNo,
                                      totalCounts: $0.totalCount,
                                      results: $0.animal)
                }
                .eraseToAnyPublisher()
        }

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
