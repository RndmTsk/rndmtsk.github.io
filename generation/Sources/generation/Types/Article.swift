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
    let intro: String
    let date: Date
    let content: String
    let tags: [String]
}

// MARK: - <Exportable>
extension Article: Exportable {
    static var preferredRawFormat: Format { .markdown }
}

// MARK: - <Templatable>
extension Article: Templatable {
    static var template: Exportable {
        Article(title: "Sample Title",
                intro: "An example of where you can put an image of a project, or anything else, along with a description.",
                date: Date(),
                content: "Sample article content.",
                tags: ["sample", "article", "todo"])
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
