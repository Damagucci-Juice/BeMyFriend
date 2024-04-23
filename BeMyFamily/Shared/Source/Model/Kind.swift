//
//  Kind.swift
//  BeMyFamily
//
//  Created by Gucci on 4/18/24.
//

import Foundation

struct Kind: Codable, Hashable, Identifiable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "kindCd"
        case name = "knm"
    }

    static let example = Kind(id: "000054", name: "골든 리트리버")
}
