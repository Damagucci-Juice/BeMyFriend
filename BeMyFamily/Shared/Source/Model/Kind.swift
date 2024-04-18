//
//  Kind.swift
//  BeMyFamily
//
//  Created by Gucci on 4/18/24.
//

import Foundation

struct Kind: Codable, Identifiable {
    var id: String
    var name: String

    enum CodingKeys: String, CodingKey {
        case id = "kindCd"
        case name = "knm"
    }
}
