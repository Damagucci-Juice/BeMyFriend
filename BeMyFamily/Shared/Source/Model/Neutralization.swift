//
//  Neutralization.swift
//  BeMyFamily
//
//  Created by Gucci on 4/23/24.
//

import Foundation

enum Neutralization: String, CaseIterable {
    case yes = "Y"
    // swiftlint: disable identifier_name
    case no = "N"
    // swiftlint: enable identifier_name
    case undefind = "U"
    case all = ""

    var id: String {
        return self.rawValue
    }

    var text: String {
        switch self {
        case .yes:
            return "예"
        case .no:
            return "아니요"
        case .undefind:
            return "미상"
        case .all:
            return "전체"
        }
    }
}
