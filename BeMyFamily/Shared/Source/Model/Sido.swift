//
//  Sido.swift
//  BeMyFamily
//
//  Created by Gucci on 4/17/24.
//

import Foundation

struct Sido: Codable, Identifiable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "orgCd"
        case name = "orgdownNm"
    }
}
