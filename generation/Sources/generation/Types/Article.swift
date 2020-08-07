//
//  Article.swift
//  generation
//
//  Created by Terry Latanville on 2020-07-30.
//

import Foundation
import Mustache

struct Article: Codable  {
    let title: String
    let intro: String = "An example of where you can put an image of a project, or anything else, along with a description." // TODO: (TL) Remove this
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

// MARK: - <MustacheBoxable>
extension Article: MustacheBoxable {
    var mustacheBox: MustacheBox {
        Box([
            "title": title,
            "intro": intro,
            "date": DateFormatter.localizedString(from: date,
                                                  dateStyle: .long,
                                                  timeStyle: .none),
            "content": content,
            "tags": tags
        ])
    }
}
