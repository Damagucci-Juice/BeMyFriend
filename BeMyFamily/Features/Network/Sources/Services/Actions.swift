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
        
        // TODO: - 깔끔한 에러처리 도입이 필요함
        func excute(_ service: SearchService) async throws -> PaginatedResponse<Animal> {
            do {
                guard let fetched = try await service.search(.animal(filteredItem: filter)) else {
                    throw HTTPError.notFoundResponse
                }
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
                
            } catch let error {
                throw error
            }
        }
    }
}


protocol Action { }
protocol AsyncAction: Action { }
