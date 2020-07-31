//
//  Encodable+WriteJSON.swift
//  generation
//
//  Created by Terry Latanville on 2020-07-30.
//

import Foundation

extension Encodable {
    func write(as format: ExportFormat, path: String, filename: String) throws {
        guard format == .json else { throw ExportableErrors.htmlEncoderUnavailable(for: Self.self) }
        try JSONEncoder().encode(self).write(to: filename, in: path)
    }
}
