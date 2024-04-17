//
//  FriendEndpoint.swift
//  BeMyFamily
//
//  Created by Gucci on 4/11/24.
//

import Foundation

enum FriendEndpoint {
    case sido
    case sigungu(sido: Int)
    case shelter(sido: Int, sigungu: Int)
    case kind(upkind: Int)
    case animal(filteredItem: AnimalFilter) // PARAMETER: page, selected Filtering list,
}

extension FriendEndpoint {
    var baseURL: URL {
        // swiftlint:disable force_unwrapping
        return URL(string: Constants.Network.baseUrlPath)!
        // swiftlint:enable force_unwrapping
    }

    var path: String {
        switch self {
        case .sido:
            return Constants.Network.sidoPath
        case .sigungu:
            return Constants.Network.sigunguPath
        case .shelter:
            return Constants.Network.shelterPath
        case .kind:
            return Constants.Network.kindPath
        case .animal:
            return Constants.Network.animalPath
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
            dict.updateValue(Constants.NetworkParameters.totalSidoCount, forKey: "numOfRows")
            dict.updateValue("1", forKey: "pageNo")
        case .sigungu(let sido):
            dict.updateValue("\(sido)", forKey: "upr_cd")
        case .shelter(let sido, let sigungu):
            dict.updateValue("\(sido)", forKey: "upr_cd")
            dict.updateValue("\(sigungu)", forKey: "org_cd")
        case .kind(let upkind):
            dict.updateValue("\(upkind)", forKey: "up_kind_cd")
        case .animal(let animalFilter):
            animalFilter.toParams().enumerated().forEach { (_, value) in
                dict.updateValue("\(value.value)", forKey: "\(value.key)")
            }
        }
        return dict
    }

    var headers: [String: String]? {
        return nil
    }
}
