//
//  Site.swift
//  generation
//
//  Created by Terry Latanville on 2020-07-30.
//

import Foundation
import Mustache

fileprivate typealias TemplateKey = String
extension String {
    static let article = "article"
    static let articles = "articles"
    static let project = "project"
    static let projects = "projects"
}

struct Site {
    // MARK: - Properties
    private static let jsonDecoder = JSONDecoder()
}

// MARK: - Data Importing
extension Site {
    private static func loadAll<T: Exportable & Codable>(_ type: T.Type) throws -> [T] {
        try type.dataFilenames()
            .compactMap { FileManager.default.contents(atPath: $0) }
            .compactMap { try jsonDecoder.decode(type, from: $0) }
    }


}

// MARK: - HTML Writing
extension Site {
    static func export() throws {
        let articles = try loadAll(Article.self)
            .sorted {
                $0.date.timeIntervalSinceReferenceDate > $1.date.timeIntervalSinceReferenceDate
        }

        let projects = try loadAll(Project.self)

        // TODO: (TL) Complete from here
        let indexTemplate = try Template(path: "./mustache/index.mustache")
        indexTemplate.register(articles, forKey: .articles)
        indexTemplate.register(projects, forKey: .projects)

        let rendering = try indexTemplate.render()
        // try rendering.write(toFile: file, atomically: true, encoding: .utf8)
        print(rendering)
    }


}
