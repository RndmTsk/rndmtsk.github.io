//
//  ExportFormat.swift
//  generation
//
//  Created by Terry Latanville on 2020-07-30.
//

import Foundation

enum ExportFormat: String {
    case json
    case html

    var suffix: String { "." + rawValue }
}
