//
//  Enums.swift
//  generator
//
//  Created by Terry Latanville on 2019-02-19.
//

import Foundation

enum Format: String {
    case json
    case html

    var suffix: String {
        return "." + rawValue
    }
}

enum ATemplate: String, Codable {
    case post, project, index, about
}
