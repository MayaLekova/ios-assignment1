//
//  MovieType.swift
//  Assignment1
//
//  Created by Maya Lekova on 2/2/17.
//  Copyright © 2017 Maya Lekova. All rights reserved.
//

import Foundation


/// Base struct for enums containing localizable string values
/// Inspired by http://stackoverflow.com/a/28213905/1540248
struct LocalizedString: ExpressibleByStringLiteral, Equatable {
    
    let v: String
    
    init(key: String) {
        self.v = NSLocalizedString(key, comment: "")
    }
    init(localized: String) {
        self.v = localized
    }
    init(stringLiteral value:String) {
        self.init(key: value)
    }
    init(extendedGraphemeClusterLiteral value: String) {
        self.init(key: value)
    }
    init(unicodeScalarLiteral value: String) {
        self.init(key: value)
    }
}

func ==(lhs:LocalizedString, rhs:LocalizedString) -> Bool {
    return lhs.v == rhs.v
}

enum MovieType: LocalizedString {
    case MTMovie
    case MTSeries
    case MTEpisode
    case MTAll
    
    var localizedString: String {
        return self.rawValue.v
    }
    
    var queryItemValue: String {
        switch self {
        case .MTMovie:
            return "movie"
        case .MTSeries:
            return "series"
        case .MTEpisode:
            return "episode"
        default:
            return ""
        }
    }
    
    init?(localizedString: String) {
        self.init(rawValue: LocalizedString(localized: localizedString))
    }
}
