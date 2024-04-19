//
//  UIConstants.swift
//  BeMyFamily
//
//  Created by Gucci on 4/19/24.
//

import UIKit

struct UIConstants {
    struct Frame {
        static let heartHeight = 28.0
        static let heartBorderHeight = 32.0
        static let shareHeight = 32.0
        static let feedImageHeight = 500.0
        static let screenWidth = UIScreen.main.bounds.width
        static let screenWidthWithPadding = screenWidth - (UIConstants.Padding.feedImemViewHorizontal * 2)
    }

    struct Padding {
        static let feedImemViewHorizontal = 8.0
    }

    struct Opacity {
        static let border = 0.85
    }

    struct Image {
        static let friendPlaceholder = "FriendPlaceholder"
        static let heart = "heart.fill"
        static let heartWithStroke = "heart"
        static let share = "square.and.arrow.up.circle.fill"
    }

    struct Radius {
        static let mainImagePlaceholder = 16.0
    }

    struct Spacing {
        static let interFeedItem = 26.0
    }

    struct Line {
        static let feedItem = 3.0
    }
}
