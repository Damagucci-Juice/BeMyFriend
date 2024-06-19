//
//  FriendEndpoint.swift
//  BeMyFamily
//
//  Created by Gucci on 4/11/24.
//

import Foundation

enum FamilyEndpoint {
    case sido
    case sigungu(sido: String)
    case shelter(sido: String, sigungu: String)
    case kind(upkind: String)
    case animal(filteredItem: AnimalFilter, page: Int)
}

extension FamilyEndpoint {
    var baseURL: URL {
        // swiftlint:disable force_unwrapping
        return URL(string: NetworkConstants.Path.baseUrl)!
        // swiftlint:enable force_unwrapping
    }

    var path: String {
        switch self {
        case .sido:
            return NetworkConstants.Path.sido
        case .sigungu:
            return NetworkConstants.Path.sigungu
        case .shelter:
            return NetworkConstants.Path.shelter
        case .kind:
            return NetworkConstants.Path.kind
        case .animal:
            return NetworkConstants.Path.animal
        }
    }

    var method: String {
        return "GET"
    }

    var parameter: [String: String] {
        var dict: [String: String] = [
            "_type": "json",
            // swiftlint:disable line_length
            "serviceKey": "dPXa2aDAK4Zlqst8P1kjsxl3oIsq49aExnzH7RhLCzUrX8rOrIkNyYRPf%2FshHLbq%2FLtgAnK7jtfeXwPSPZpr5g%3D%3D"
            // swiftlint:enable line_length
        ]

        switch self {
        case .sido:
            dict.updateValue(NetworkConstants.Params.totalSidoCount, forKey: "numOfRows")
            dict.updateValue("1", forKey: "pageNo")
        case .sigungu(let sido):
            dict.updateValue(sido, forKey: "upr_cd")
        case .shelter(let sido, let sigungu):
            dict.updateValue("\(sido)", forKey: "upr_cd")
            dict.updateValue("\(sigungu)", forKey: "org_cd")
        case .kind(let upkind):
            dict.updateValue("\(upkind)", forKey: "up_kind_cd")
        case .animal(let animalFilter, let page):
            animalFilter.toParams().enumerated().forEach { (_, value) in
                dict.updateValue("\(value.value)", forKey: "\(value.key)")
            }
            dict.updateValue("\(page)", forKey: "pageNo")
        }
        return dict
    }

    var headers: [String: String]? {
        return nil
    }
}
