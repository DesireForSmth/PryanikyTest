//
//  NetworkService.swift
//  PryanikyTest
//
//  Created by Александр Сетров on 20.03.2021.
//

import Foundation

protocol NetworkingProtocol {
    func getMainData(completion: @escaping ((MainData.ViewDataStruct) -> Void))
}

class NetworkService: NetworkingProtocol {

    func getMainData(completion: @escaping ((MainData.ViewDataStruct) -> Void)) {
        let url = URL(string: "https://pryaniky.com/static/json/sample.json")!
        let task = URLSession.shared.dataTask(with: url) { (data, responce, error) in
            do {
                let decoder = JSONDecoder()
                let resultJSON = try decoder.decode(NetworkResponseStruct.self, from: data!)
                let result = self.parseMainData(responce: resultJSON)
                print(result)
                completion(result)
            } catch {
                print(error.localizedDescription)
            }
            _ = responce
            _ = error
        }
        task.resume()
    }

}

extension NetworkService {

    private func parseMainData(responce: NetworkResponseStruct) -> MainData.ViewDataStruct {
        var views: [String] = []
        var dataItems: [DataItem] = []
        responce.data.forEach {
            let dataItem = self.parseDataStruct(responce: $0)
            dataItems.append(dataItem)
        }
        responce.view.forEach {
            views.append($0)
        }
        let result = MainData.ViewDataStruct(data: dataItems, views: views)
        return result
    }

    private func parseDataStruct(responce: DataStruct) -> DataItem {
        let dataContent = self.parseNodeData(responce: responce.data)
        let dataType: DataItem.DataType!
        switch responce.name {
        case .hz:
            dataType = .hz
        case .selector:
            dataType = .selector
        case .picture:
            dataType = .picture
        }
        let result = DataItem(name: responce.name.rawValue, type: dataType, dataContent: dataContent)
        return result
    }

    private func parseNodeData(responce: NodeDataStruct) -> DataContent {
        let variants: [SelectionItem]?
        switch responce.variants {
        case .none:
            variants = nil
        case .some(_):
            let responceVariants = responce.variants!
            variants = self.parseVariants(responce: responceVariants)
        }
        let result = DataContent(text: responce.text, url: responce.url, selectedId: responce.selectedId, variants: variants)
        return result
    }

    private func parseVariants(responce: [VariantStruct]) -> [SelectionItem] {
        var result: [SelectionItem] = []
        responce.forEach {
            let item = SelectionItem(id: $0.id, text: $0.text)
            result.append(item)
        }
        return result
    }

}
