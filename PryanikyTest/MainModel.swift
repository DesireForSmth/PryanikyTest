//
//  MainModel.swift
//  PryanikyTest
//
//  Created by Александр Сетров on 20.03.2021.
//

import Foundation

enum MainData {
    case initial
    case loading(ViewDataStruct)
    case failure(ViewDataStruct)
    case success(ViewDataStruct)

    struct ViewDataStruct {
        let data: [DataItem]?
        let views: [String]?
    }
}

struct DataItem {
    let name: String
    let type: DataType
    let dataContent: DataContent

    enum DataType {
        case hz
        case picture
        case selector
    }
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
}
