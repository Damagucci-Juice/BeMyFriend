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

        func excute(_ sidoCode: String) async throws -> Response<Sigungu> {
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
    }

    struct FetchShelter: AsyncAction {
        let service: FriendSearchService

        func excute(_ sidoCode: String, _ sigunguCode: String) async throws -> Response<Shelter> {
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
    }

    struct FetchKind: AsyncAction {
        let service: FriendSearchService

        func excute(_ upkindCode: String) async throws -> Response<Kind> {
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
    }

    struct FetchAnimal: AsyncAction {
        let service: FriendSearchService
        let filter: AnimalFilter
        let page: Int

        func excute() async throws -> PaginatedResponse<Animal> {
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
