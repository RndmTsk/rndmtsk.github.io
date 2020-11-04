//
//  Exportable.swift
//  generation
//
//  Created by Terry Latanville on 2020-07-30.
//

import Foundation

struct ExportableErrors {
    static func htmlEncoderUnavailable<T>(for type: T.Type) -> Error {
        NSError(domain: "generator.encode.html", code: 0, userInfo: [
            NSLocalizedDescriptionKey: "\(String(describing: type)) does not support HTML encoding."
        ])
    }
}

protocol Exportable {
    /// The title of the `Exportable`, used for `filename` creation.
    var title: String { get }

    /// Expected format that raw data for this `Exportable` will use.
    static var preferredRawFormat: Format { get }

    /// The name of the raw data file for this `Exportable` type.
    var rawFormatFilename: String { get }

    /// Based on `Format`, returns where the raw or exported files are stored for this `Exportable`
    ///
    /// NOTE: `.json`, and `.markdown` are considered "raw" types and are stored in `data-<type>s`.
    ///       `html` is considered a "final result" and is stored in `<type>s`
    ///
    /// - Parameter format: A `Format` that this file will use.
    static func path(for format: Format) -> String

    /// The name of the file without any path components.
    ///
    /// - Parameter format: A `Format`, used to determine the file extension (e.g. `.html`, `.json`, `.md`)
    func filename(for format: Format) -> String

    /// Exports `self` using the `preferredRawFormat`.
    func export() throws

    /// Exports `self` using the specified `format`.
    ///
    /// - Parameter format: A `Format`, used to determine the file extension (e.g. `.html`, `.json`, `.md`)
    func export(as format: Format) throws
}

// MARK: - Default Implementations
extension Exportable {
    var rawFormatFilename: String { filename(for: Self.preferredRawFormat) }
    static func path(for format: Format) -> String {
        let typename = String(describing: Self.self)
            .lowercased()
            .components(separatedBy: ".")
            .last!
        switch format {
        case .json, .markdown: return "./data-\(typename)s"
        case .html: return "./\(typename)s"
        }
    }

    static func dataFilenames() throws -> [String] {
        let dataPath = path(for: .json)
        return try FileManager.default
            .contentsOfDirectory(atPath: dataPath)
            .filter { $0.hasSuffix(Self.preferredRawFormat.suffix) }
            .map { dataPath.appending("/").appending($0) }
    }

    func filename(for format: Format) -> String {
        title.lowercased().replacingOccurrences(of: " ", with: "-") + format.suffix
    }

    func export() throws {
        try export(as: Self.preferredRawFormat)
    }
}

// MARK: - <Exportable> x <Encodable>
extension Exportable where Self: Encodable {
    func export(as format: Format) throws {
        let filename = self.filename(for: format)
        let path = Self.path(for: format)
        try write(as: format,
                  path: path,
                  filename: filename)
    }
}
