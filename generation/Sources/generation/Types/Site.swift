//
//  Site.swift
//  generation
//
//  Created by Terry Latanville on 2020-07-30.
//

import Foundation
import Mustache

fileprivate typealias TemplateKey = String
extension TemplateKey {
    static let featuredArticle = "featuredarticle"
    static let secondArticle = "secondarticle"
    static let thirdArticle = "thirdarticle"
    static let project = "project"
    static let projects = "projects"
    static let apps = "apps"
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
        let apps = try loadAll(App.self)

        let indexTemplate = try Template(path: "./mustache/index.mustache")
        configure(articles, in: indexTemplate)
        configure(projects, in: indexTemplate)
        indexTemplate.register(apps, forKey: .apps)

        let rendering = try indexTemplate.render()
        // try rendering.write(toFile: file, atomically: true, encoding: .utf8)
        print(rendering)
    }

    private static func configure(_ articles: [Article], in template: Template) {
        guard let featuredArticle = articles.first else { return }
        template.register(featuredArticle, forKey: .featuredArticle)

        // First "extra" article
        guard articles.count > 1 else { return }
        template.register(articles[1], forKey: .secondArticle)

        // Second "extra" article
        guard articles.count > 2 else { return }
        template.register(articles[2], forKey: .thirdArticle)
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
