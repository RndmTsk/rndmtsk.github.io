//
//  App.swift
//  generation
//
//  Created by Terry Latanville on 2020-08-07.
//

import Foundation
import Mustache

struct App: Codable {
    let title: String
    let icon: String

    static var template: App {
        App(title: "Sample App",
            icon: "sample-app.png")
    }
}

// MARK: - <Exportable>
extension App: Exportable {
    static func path(for format: ExportFormat) -> String {
        switch format {
        case .json: return "./data-apps"
        case .html: return "./apps"
        }
    }
}

// MARK: - <MustacheBoxable>
extension App: MustacheBoxable {
    var mustacheBox: MustacheBox {
        Box([
            "title": title,
            "icon": icon
        ])
    }
}
