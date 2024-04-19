//
//  FriendMenu.swift
//  BeMyFamily
//
//  Created by Gucci on 4/19/24.
//

import Foundation

enum FriendMenu: CaseIterable {
    case feed, favorite

    var title: String {
        switch self {
        case .feed:
            return "Feed"
        case .favorite:
            return "Favorite"
        }
    }
}
