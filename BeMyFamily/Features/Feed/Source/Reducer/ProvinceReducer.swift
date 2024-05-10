//
//  ProvinceReducer.swift
//  BeMyFamily
//
//  Created by Gucci on 4/30/24.
//

import Foundation

@Observable
final class ProvinceReducer: ObservableObject {
    private let service: FamilyService

    private(set) var kind = [Upkind: [Kind]]()
    private(set) var sido = [Sido]()    // MAYBE: - 1안, Dictionary로 빼기, 2안 Sido안에 Sigungu, Shelter를 포함한 새로운 Entity를 제작
    private(set) var province = [Sido: [Sigungu]]()
    private(set) var shelter = [Sigungu: [Shelter]]()

    init(service: FamilyService = .init(session: .shared)) {
        self.service = service

        Task {
            do {
                self.kind = try await Actions.FetchKind(service: service).execute(by: Upkind.allCases)
                self.sido = try await Actions.FetchSido(service: service).execute().results
                self.province = await Actions.FetchSigungu(service: service).execute(by: sido)
                self.shelter = await Actions.FetchShelter(service: service).execute(by: province)
            } catch {
                print("failed at fetching kind using by upkind")
            }
        }
    }
}
