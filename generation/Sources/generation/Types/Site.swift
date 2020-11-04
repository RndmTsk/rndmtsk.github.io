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
    static let codeSnippet1 = "code-snippet-1"
    static let codeSnippet2 = "code-snippet-2"
    static let codeSnippet3 = "code-snippet-3"
}

struct Site {
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
    private static func jsonDecodeAll<T: Exportable & Decodable>(_ type: T.Type) throws -> [T] {
        try type.dataFilenames()
            .compactMap { FileManager.default.contents(atPath: $0) }
            .compactMap { try jsonDecoder.decode(type, from: $0) }
    }

    private static func markdownToHTML<T: Exportable>(_ type: T.Type) throws -> [String] {
        try type.dataFilenames()
            .compactMap { FileManager.default.contents(atPath: $0) }
            .compactMap { String(data: $0, encoding: .utf8) }
            .compactMap { markdownParser.html(from: $0) }
            .map { $0.removingHTMLEntities() }
    }

    // MARK: - HTML Writing
    static func export() throws {
        // TODO: (TL) This is very much brute force and inelegant
        let articles = try markdownToHTML(Article.self)
        let projects = try jsonDecodeAll(Project.self)
        let apps = try jsonDecodeAll(App.self)

        let indexTemplate = try Template(path: "./mustache/index.mustache")
        configure(articles, in: indexTemplate)
        configure(projects, in: indexTemplate)
        indexTemplate.register(apps, forKey: .apps)
        indexTemplate.register("\"Test snippet 1\"", forKey: .codeSnippet1)
        indexTemplate.register("\"Test snippet 2\"", forKey: .codeSnippet2)
        indexTemplate.register("\"Test snippet 3\"", forKey: .codeSnippet3)

        let rendering = try indexTemplate.render()
        // let file = URL(fileURLWithpath: "../index.html")
        // try rendering.write(toFile: file, atomically: true, encoding: .utf8)
        print(rendering)
    }

    private static func configure(_ articleHTML: [String], in template: Template) {
        guard let featuredArticle = articleHTML.first else { return }
        template.register(featuredArticle, forKey: .featuredArticle)

        // First "extra" article
        guard articleHTML.count > 1 else { return }
        template.register(articleHTML[1], forKey: .secondArticle)

        // Second "extra" article
        guard articleHTML.count > 2 else { return }
        template.register(articleHTML[2], forKey: .thirdArticle)
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
