//
//  MainViewModel.swift
//  PryanikyTest
//
//  Created by Александр Сетров on 20.03.2021.
//

import Foundation

protocol MainViewModelProtocol {
    var updateMainData: ((MainData) -> ())? { get set }
    var updateData: ((MainData) -> ())? { get set }
    func fetchData()
}

final class MainViewModel: MainViewModelProtocol {
    var updateData: ((MainData) -> ())?
    var updateMainData: ((MainData) -> ())?
    let networkService = NetworkService()

    init() {
        updateMainData?(.initial)
    }

    func fetchData() {
        updateMainData?(.loading(MainData.ViewDataStruct(data: nil, views: nil)))
        networkService.getMainData { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { [self] in
                self.updateMainData?(.success(result))
            }
        }
    }

}
