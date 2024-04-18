//
//  Response.swift
//  BeMyFamily
//
//  Created by Gucci on 4/18/24.
//

import Foundation

// MARK: - API Response for "Sigungu, Shelter and Kind"
struct Response<T: Codable>: Codable {
    let results: [T]
}
