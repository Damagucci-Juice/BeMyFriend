//
//  PaginatedResponse.swift
//  BeMyFamily
//
//  Created by Gucci on 4/14/24.
//

import Foundation

struct PaginatedResponse<T: Codable>: Codable {
    let numbersOfRow: Int?
    let pageNumber: Int?
    let totalCounts: Int?
    let results: [T]
}
