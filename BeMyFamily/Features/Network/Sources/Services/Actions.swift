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
        
    }
    
    struct FetchSigungu: AsyncAction {
        
    }
    
    struct FetchShelter: AsyncAction {
        
    }
    
    struct FetchKind: AsyncAction {
        
    }
    
    struct FetchAnimal: AsyncAction {
        let filter: AnimalFilter
        let page: Int
        
        func excute(_ service: SearchService) -> AnyPublisher<PaginatedResponse<AnimalDTO>, Error> {
            let animalPublisher = service.search(.animal(filteredItem: filter))
            return animalPublisher
                .decode(
                    type: AnimalResponse.self,
                    decoder: JSONDecoder()
                )
                .map(\.response.body)
                .map {
                    PaginatedResponse(numbersOfRow: $0.numOfRows,
                                      pageNumber: $0.pageNo,
                                      totalCounts: $0.totalCount,
                                      results: $0.items.item)
                }
                .eraseToAnyPublisher()
        }
        
        // TODO: - 깔끔한 에러처리 도입이 필요함
        func excute(_ service: SearchService) async throws -> PaginatedResponse<AnimalDTO> {
            do {
                guard let fetched = try await service.search(.animal(filteredItem: filter)) else {
                    throw HTTPError.notFoundResponse
                }
                do {
                    let decoded = try JSONDecoder().decode(AnimalResponse.self, from: fetched).response.body
                    return PaginatedResponse(numbersOfRow: decoded.numOfRows,
                                             pageNumber: decoded.pageNo,
                                             totalCounts: decoded.totalCount,
                                             results: decoded.items.item)
                } catch let error {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                    print("JSON of Data")
                    print(fetched.prettyPrintedJSONString ?? "")
                    throw error
                }
                
            } catch let error {
                throw error
            }
        }
    }
}


protocol Action { }
protocol AsyncAction: Action { }
