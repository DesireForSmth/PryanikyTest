//
//  NetworkResponseStruct.swift
//  PryanikyTest
//
//  Created by Александр Сетров on 20.03.2021.
//

import Foundation

struct NetworkResponseStruct: Codable {
    let data: [DataStruct]
    let view: [String]

    enum CodingKeys: String, CodingKey {
        case data, view
    }
}

struct DataStruct: Codable {
    let name: Name
    let data: NodeDataStruct

    enum CodingKeys: String, CodingKey {
        case name, data
    }
}

struct NodeDataStruct: Codable {
    let text: String?
    let url: String?
    let selectedId: Int?
    let variants: [VariantStruct]?

    enum CodingKeys: String, CodingKey {
        case text, url, selectedId, variants
    }
}

struct VariantStruct: Codable {
    let id: Int
    let text: String

    enum CodingKeys: String, CodingKey {
        case id, text
    }
}

enum Name: String, Codable {
    case hz = "hz"
    case selector = "selector"
    case picture = "picture"
}
