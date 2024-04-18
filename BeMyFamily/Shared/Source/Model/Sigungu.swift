//
//  Sigungu.swift
//  BeMyFamily
//
//  Created by Gucci on 4/18/24.
//

import Foundation

struct Sigungu: Codable, Identifiable {
    let id: String
    let name: String
    let sidoId: String

    enum CodingKeys: String, CodingKey {
        case id = "orgCd"
        case name = "orgdownNm"
        case sidoId = "uprCd"
    }
}
