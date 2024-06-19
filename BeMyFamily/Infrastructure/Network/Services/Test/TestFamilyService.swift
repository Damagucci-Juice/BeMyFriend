//
//  TestFamilyService.swift
//  BeMyFamily
//
//  Created by Gucci on 5/10/24.
//

import Foundation

final class TestFamilyService: SearchService {
    let isEmptyResultTest: Bool
    init(isEmptyResultTest: Bool = false) {
        self.isEmptyResultTest = isEmptyResultTest
    }

    func search(_ endpoint: FamilyEndpoint) async throws -> Data {
        try await Task.sleep(nanoseconds: UInt64.random(in: 100_000_000...500_000_000))

        let fileName: String

        switch endpoint {
        case .sido:
            fileName = Constants.TestFile.sido
        case .sigungu:
            fileName = Constants.TestFile.sigungu
        case .kind:
            fileName = Constants.TestFile.kind
        case .shelter:
            fileName = isEmptyResultTest ? Constants.TestFile.emptyShelter : Constants.TestFile.shelter
        case .animal:
            fileName = isEmptyResultTest ? Constants.TestFile.emptyAnimal : Constants.TestFile.animal
        }

        return loadData(fileName)
    }

    func performRequest(urlRequest: URLRequest) async throws -> Data {
        return Data()
    }
}
