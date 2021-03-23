//
//  MainCellView.swift
//  PryanikyTest
//
//  Created by Александр Сетров on 22.03.2021.
//

import UIKit

class MainCellView: UIView {

    var dataTitle: String?

    var cellImage: UIImage?

    var cellSelectionItems: [SelectionItem]?

    weak var cellSelectionDelegate: MainTableViewCellSelectionDelegate?

    struct Constants {
        static let inset = CGFloat(16)
        static let imageSize = CGFloat(100)
    }
}
