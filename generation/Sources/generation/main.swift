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
    enum Errors: Error {
        case invalidArgument
    }
    public static let configuration = CommandConfiguration(abstract: "A Swift command-line tool to manage static site generation",
                                                           subcommands: [SiteCommand.self,
                                                                         TemplateCommand.self])
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

struct TemplateCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(commandName: "template",
                                                           abstract: "Generates a new sample of the specified type")
    @Argument(help: "The type of template to generate, options available: 'article', 'project'")
    var type: String

    func run() throws {
        if type == "article" {
            try Article
                .template
                .export(as: .json)
        } else if type == "project" {
            try Project
                .template
                .export(as: .json)
        } else {
            throw Generation.Errors.invalidArgument
        }
    }
}
