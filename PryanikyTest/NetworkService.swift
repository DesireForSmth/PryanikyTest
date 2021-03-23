//
//  NetworkService.swift
//  PryanikyTest
//
//  Created by Александр Сетров on 20.03.2021.
//

import Foundation

protocol NetworkingProtocol {
    func getMainData(completion: @escaping ((ViewDataStruct) -> Void))
}

class NetworkService: NetworkingProtocol {

    func getMainData(completion: @escaping ((ViewDataStruct) -> Void)) {
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

    func getImage(from urlString: String, completion: @escaping ((Data) -> Void)) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, responce, error) in
            guard let data = data else { return }
            completion(data)
        }
        task.resume()
    }
}

extension NetworkService {

    private func parseMainData(responce: NetworkResponseStruct) -> ViewDataStruct {
        var views: [String] = []
        var dataItems: [DataItem] = []
        responce.data.forEach {
            let dataItem = self.parseDataStruct(responce: $0)
            dataItems.append(dataItem)
        }
        responce.view.forEach {
            views.append($0)
        }
        let result = ViewDataStruct(data: dataItems, views: views)
        return result
    }

    private func parseDataStruct(responce: DataStruct) -> DataItem {
        let dataContent = self.parseNodeData(responce: responce.data)
        let dataType: DataType!
        switch responce.name {
        case .hz:
            dataType = .hz
        case .selector:
            dataType = .selector
        case .picture:
            dataType = .picture
        }
        let result = DataItem(name: responce.name.rawValue, dataContent: dataContent, dataType: dataType)
        return result
    }

    private func parseNodeData(responce: NodeDataStruct) -> DataContent {
        var variants: [SelectionItem]?
        switch responce.variants {
        case .none:
            variants = nil
        case .some(_):
            var responceVariants = responce.variants!
            variants = self.parseVariants(responce: responceVariants, selectedID: responce.selectedId)
        }
        let result = DataContent(text: responce.text, url: responce.url, selectedId: responce.selectedId, variants: variants)
        return result
    }

    private func parseVariants(responce: [VariantStruct], selectedID: Int?) -> [SelectionItem] {
        var result: [SelectionItem] = []
        responce.forEach {
            let selected: Bool = selectedID == $0.id
            let item = SelectionItem(id: $0.id, text: $0.text, isSelected: selected)
            result.append(item)
        }
        return result
    }

}
