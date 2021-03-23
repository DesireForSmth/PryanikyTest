//
//  MainCellViewModel.swift
//  PryanikyTest
//
//  Created by Александр Сетров on 21.03.2021.
//

import Foundation
import UIKit

protocol MainCellViewModelProtocol {
    var actionBlock: ((String) -> Void)? { get set }
    var cellDataStruct: DataItem? { get set }
    var cellData: ((DataItem) -> Void)? { get set }
    var cellImage: ((UIImage?) -> Void)? { get set }
    var cellText: ((String?) -> Void)? { get set }
    var cellSelector: (([SelectionItem]) -> Void)? { get set }
    var shouldLayoutTableView: (() -> Void)? { get set }
    func updateView() -> Void
}

class MainCellViewModel: MainCellViewModelProtocol {
    var cellData: ((DataItem) -> Void)?
    
    func updateView() {
        self.shouldLayoutTableView?()
    }

    var shouldLayoutTableView: (() -> Void)?
    var cellText: ((String?) -> Void)? {
        didSet {
            cellText?(cellDataStruct?.dataContent.text)
        }
    }

    var cellSelector: (([SelectionItem]) -> Void)? {
        didSet {
            if let variants = self.cellDataStruct?.dataContent.variants {
                cellSelector?(variants)
            }
        }
    }

    var cellImage: ((UIImage?) -> Void)? {
        didSet {
            if let urlString = self.cellDataStruct?.dataContent.url {
                self.fetchImageData(from: urlString)
            }
        }
    }

    var cellDataStruct: DataItem? {
        didSet {
            if let urlString = cellDataStruct?.dataContent.url {
                self.fetchImageData(from: urlString)
            }
            self.cellText?(cellDataStruct?.dataContent.text ?? "")
            if let variants = cellDataStruct?.dataContent.variants {
                self.cellSelector?(variants)
            }
        }
    }

    var actionBlock: ((String) -> Void)?
    let networkService = NetworkService()

    private func fetchImageData(from urlString: String) {
        self.networkService.getImage(from: urlString) { [ weak self ] result in
            DispatchQueue.main.async { [ self ] in
                guard let image = UIImage(data: result) else { return }
                self?.cellImage?(image)
            }
        }
    }
}
