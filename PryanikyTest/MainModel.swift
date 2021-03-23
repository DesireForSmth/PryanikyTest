//
//  MainModel.swift
//  PryanikyTest
//
//  Created by Александр Сетров on 20.03.2021.
//

import Foundation

enum MainDataState {
    case initial
    case loading
    case failure
    case success
}

struct ViewDataStruct {
    let data: [DataItem]?
    let views: [String]?
}

struct DataItem {
    let name: String
    let dataContent: DataContent
    let dataType: DataType
}

struct DataContent {
    let text: String?
    let url: String?
    let selectedId: Int?
    let variants: [SelectionItem]?
}

struct SelectionItem {
    let id: Int
    let text: String
    var isSelected: Bool = false
}

enum DataType: String {
    case hz = "hz"
    case picture = "picture"
    case selector = "selector"
}
