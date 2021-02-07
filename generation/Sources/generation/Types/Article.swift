//
//  Article.swift
//  generation
//
//  Created by Terry Latanville on 2020-07-30.
//

import Foundation
import Mustache

struct Article: Codable {
    let title: String
    let topic: String
    let content: String

//    let intro: String
//    let date: Date
//    let content: String
//    let tags: [String]

    var link: String {
        (title
            .lowercased()
            .replacingOccurrences(of: " ", with: "-")
            .replacingOccurrences(of: ":", with: "-")
            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ??
            "article-\(title.hash)").appending(".html")
    }
}

extension Article: Importable {
    init(filename: String, content: String) {
        let fileURL = URL(string: filename)!
        let title = fileURL.lastPathComponent
            .replacingOccurrences(of: fileURL.pathExtension, with: "")
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: ".", with: "")
            .capitalized

        // TODO: (TL) add icon or something based on base path (e.g. Swift root directory)
        self.init(title: title.removingPercentEncoding ?? title,
                  topic: "Swift",
                  content: content)
    }
}

// MARK: - <Exportable>
extension Article: Exportable {
    static var preferredRawFormat: Format { .markdown }
}

// MARK: - <Templatable>
extension Article: Templatable {
    static var template: Exportable {
        Article(title: "Sample Title",
                topic: "Swift",
                content: "An example of where you can put an image of a project, or anything else, along with a description.")
    }
}

// MARK: - <MustacheBoxable>
extension Article: MustacheBoxable {
    var mustacheBox: MustacheBox {
        Box([
            "title": title,
            "topic": topic,
            "content": content,
            "link": link
        ])
    }
}
