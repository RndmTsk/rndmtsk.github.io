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

    static func jsonEncoderUnavailable<T>(for type: T.Type) -> Error {
        NSError(domain: "generator.encode.json", code: 0, userInfo: [
            NSLocalizedDescriptionKey: "\(String(describing: type)) does not support JSON encoding."
        ])
    }
}


protocol Exportable {
    var title: String { get }
    static func path(for format: ExportFormat) -> String
    func filename(for format: ExportFormat) -> String
    func export(as format: ExportFormat) throws
}

extension Exportable {
    func filename(for format: ExportFormat) -> String {
        title.lowercased().replacingOccurrences(of: " ", with: "-") + format.suffix
    }

    static func dataFilenames() throws -> [String] {
        let dataPath = path(for: .json)
        return try FileManager.default
            .contentsOfDirectory(atPath: dataPath)
            .filter { $0.hasSuffix(Format.json.suffix) }
            .map { dataPath.appending("/").appending($0) }
    }
}

extension Exportable where Self: Encodable {
    func export(as format: ExportFormat) throws {
        let filename = self.filename(for: format)
        let path = Self.path(for: format)
        try write(as: format,
                  path: path,
                  filename: filename)
    }
}
