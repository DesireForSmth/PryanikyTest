//
//  MainViewModel.swift
//  PryanikyTest
//
//  Created by Александр Сетров on 20.03.2021.
//

import Foundation

protocol MainViewModelProtocol {
    var updateDataState: ((MainDataState) -> ())? { get set }
    func fetchData()
    func getCellModels() -> [MainCellViewModelProtocol]
}

final class MainViewModel: MainViewModelProtocol {

    var cellsData: [DataItem]
    var viewOrder: [String]
    var updateDataState: ((MainDataState) -> ())?
    let networkService = NetworkService()
    var cellModels: [MainCellViewModelProtocol]

    init() {
        updateDataState?(.initial)
        self.cellsData = []
        self.cellModels = []
        self.viewOrder = []
    }

    func fetchData() {
        updateDataState?(.loading)
        networkService.getMainData { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { [ self ] in
                self.cellsData = result.data ?? self.cellsData
                self.viewOrder = result.views ?? self.viewOrder
                self.makeCellModels()
                self.updateDataState?(.success)
            }
        }
    }

    func getCellModels() -> [MainCellViewModelProtocol] {
        return self.cellModels
    }

    private func makeCellModels() {
        var models: [MainCellViewModel] = []
        self.viewOrder.forEach {
            for data in self.cellsData {
                if data.dataType.rawValue == $0 {
                    let model = MainCellViewModel()
                    model.cellDataStruct = data
                    models.append(model)
                }
            }
        }
        self.cellModels = models
    }
}
