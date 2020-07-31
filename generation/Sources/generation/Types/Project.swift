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

    static var template: Project {
        Project(title: "Sample Title",
                url: "https://github.com/RndmTsk/GLSLVisualizer-iOS",
                tagline: "Learning",
                languages: ["Objective-C", "OpenGL"])
    }
}

// MARK: - <Exportable>
extension Project: Exportable {
    static func path(for format: ExportFormat) -> String {
        switch format {
        case .json: return "./data-projects"
        case .html: return "./projects"
        }
    }
}

// MARK: - <MustacheBoxable>
extension Project: MustacheBoxable {
    var mustacheBox: MustacheBox {
        Box([
            "title": title,
            "url": url,
            "tagline": tagline,
            "languages": languages
        ])
    }
}
