//
//  Article.swift
//  generation
//
//  Created by Terry Latanville on 2020-07-30.
//

import Foundation

struct Article: Codable  {
    let title: String
    let date: Date
    let content: String
    let tags: [String]

    static var template: Article {
        Article(title: "Sample Title",
                date: Date(),
                content: "Sample article content.",
                tags: ["sample", "article", "todo"])
    }
}

// MARK: - <Exportable>
extension Article: Exportable {
    static func path(for format: ExportFormat) -> String {
        switch format {
        case .json: return "./data-articles"
        case .html: return "./articles"
        }
    }
}
