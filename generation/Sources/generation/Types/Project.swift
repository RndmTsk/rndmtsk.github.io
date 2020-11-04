//
//  Project.swift
//  generation
//
//  Created by Terry Latanville on 2020-07-30.
//

import Foundation
import Mustache

struct Project: Codable {
    let title: String
    let url: String
    let tagline: String
    let languages: [String]
}

// MARK: - <Exportable>
extension Project: Exportable {
    static var preferredRawFormat: Format { .json }
}

// MARK: - <Templatable>
extension Project: Templatable {
    static var template: Exportable {
        Project(title: "Sample Title",
                url: "https://github.com/RndmTsk/GLSLVisualizer-iOS",
                tagline: "Learning",
                languages: ["Objective-C", "OpenGL"])
    }
}

// MARK: - <MustacheBoxable>
extension Project: MustacheBoxable {
    var mustacheBox: MustacheBox {
        Box([
            "title": title,
            "url": url,
            "tagline": tagline,
            "languages": languages.joined(separator: ", ")
        ])
    }
}
