import Foundation
import ArgumentParser

/* Former command
func performAction(for command: String, with context: ArraySlice<String>) throws {
    if let exportableType = command.exportableType {
        try exportableType.init(context: context).export(as: .json)
    } else if command == "website" {
        try Website().export()
    } else {
        printUsage(2)
    }
}
*/


// MARK: - Main
struct Generation: ParsableCommand {
    public static let configuration = CommandConfiguration(abstract: "A Swift command-line tool to manage static site generation",
                                                           subcommands: [SiteCommand.self, ArticleCommand.self, ProjectCommand.self])
    init() {}
}

Generation.main()

// MARK: - Subcommands
struct SiteCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(commandName: "site",
                                                           abstract: "Generates a static website based on JSON data and Mustache files")
    func run() throws {
        try Site.export()
    }
}

struct ArticleCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(commandName: "article",
                                                           abstract: "Generates an article template")
    func run() throws {
        try Article
            .template
            .export(as: .json)
    }
}

struct ProjectCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(commandName: "project",
                                                           abstract: "Generates a project template")
    func run() throws {
        try Project
            .template
            .export(as: .json)
    }
}
