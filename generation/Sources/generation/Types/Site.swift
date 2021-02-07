//
//  Site.swift
//  generation
//
//  Created by Terry Latanville on 2020-07-30.
//

import Foundation
import Mustache
import Ink
import Splash
import HTMLString

fileprivate typealias TemplateKey = String
extension TemplateKey {
    static let featuredArticle = "featuredarticle"
    static let secondArticle = "secondarticle"
    static let thirdArticle = "thirdarticle"
    static let project = "project"
    static let projects = "projects"
    static let apps = "apps"
    static let articles = "articles"
}

struct Site {
    // MARK: - Errors
    static let invalidPreferredFormat = NSError(domain: "todo", code: 0)

    // MARK: - Properties
    private static let jsonDecoder = JSONDecoder()
    private static let markdownParser: MarkdownParser = {
        let highlighter = SyntaxHighlighter(format: HTMLOutputFormat())
        var parser = MarkdownParser()
        let codeBlockModifier = Modifier(target: .codeBlocks) {
            let html = String($0.html)
            return highlighter.highlight(html)
        }
        parser.addModifier(codeBlockModifier)
        return parser
    }()

    // MARK: - Data Importing
    // TODO: (TL) This is very much brute force and inelegant - improve `Importable`
    private static func jsonDecodeAll<T: Exportable & Decodable>(_ type: T.Type) throws -> [T] {
        try type.dataFilenames()
            .compactMap { FileManager.default.contents(atPath: $0) }
            .compactMap { try jsonDecoder.decode(type, from: $0) }
    }

    private static func loadMarkdown<T: Importable>(_ type: T.Type) throws -> [T] {
        guard type.preferredRawFormat == .markdown else { throw Self.invalidPreferredFormat }
        return try type.dataFilenames()
            .compactMap { Intermediary(filename: $0,
                                       possibleData: FileManager.default.contents(atPath: $0)) }
            .compactMap { intermediary in
                T(filename: intermediary.filename,
                            content: markdownParser
                                .html(from: intermediary.content)
                                .removingHTMLEntities())
            }
    }

    // MARK: - HTML Writing
    static func export() throws {
        // Additional functions
        let lowercase = Filter { Rendering($0.string.lowercased()) }

        // Data
        let articles = try loadMarkdown(Article.self)
        let projects = try jsonDecodeAll(Project.self)
        let apps = try jsonDecodeAll(App.self)

        let indexTemplate = try Template(path: "./mustache/index.mustache")

        configure(projects, in: indexTemplate)
        indexTemplate.register(apps, forKey: .apps)
        indexTemplate.register(articles, forKey: .articles)
        indexTemplate.register(lowercase, forKey: "lowercase")

        let rendering = try indexTemplate.render()
        // let file = URL(fileURLWithpath: "../index.html")
        // try rendering.write(toFile: file, atomically: true, encoding: .utf8)
        print(rendering)
    }

    private static func configure(_ projects: [Project], in template: Template) {
        var projectGroups: [[Project]] = []
        for index in stride(from: 0, to: projects.count, by: 3) {
            var projectGroup = [projects[index]]
            if index + 1 < projects.count {
                projectGroup.append(projects[index + 1])
            }
            if index + 2 < projects.count {
                projectGroup.append(projects[index + 2])
            }
            projectGroups.append(projectGroup)
        }
        template.register(projectGroups, forKey: .projects)
    }
}
