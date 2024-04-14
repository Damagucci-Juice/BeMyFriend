//
//  FriendEndpoint.swift
//  BeMyFamily
//
//  Created by Gucci on 4/11/24.
//

import Foundation

enum FriendEndpoint {
    case sido(page: Int)   // page num을 1~5번까지 호출해야함
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
        case .sido(_):
            return Constants.Network.sidoPath
        case .sigungu(_):
            return Constants.Network.sigunguPath
        case .shelter(_, _):
            return Constants.Network.shelterPath
        case .kind(_):
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
            "serviceKey": "dPXa2aDAK4Zlqst8P1kjsxl3oIsq49aExnzH7RhLCzUrX8rOrIkNyYRPf%2FshHLbq%2FLtgAnK7jtfeXwPSPZpr5g%3D%3D"
            // 오류키     : "dPXa2aDAK4Zlqst8P1kjsxl3oIsq49aExnzH7RhLCzUrX8rOrIkNyYRPf%252FshHLbq%252FLtgAnK7jtfeXwPSPZpr5g%253D%253D" // % -> %25
            // 2dhfb    : "dPXa2aDAK4Zlqst8P1kjsxl3oIsq49aExnzH7RhLCzUrX8rOrIkNyYRPf%252FshHLbq%252FLtgAnK7jtfeXwPSPZpr5g%253D%253D"
            // 3 error  : "dPXa2aDAK4Zlqst8P1kjsxl3oIsq49aExnzH7RhLCzUrX8rOrIkNyYRPf%2FshHLbq%2FLtgAnK7jtfeXwPSPZpr5g%3D%3D"
        ]
        
        switch self {
        case .sido(let page):
            dict.updateValue("4", forKey: "numOfRows")
            dict.updateValue("\(page)", forKey: "pageNo")
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
