//
//  MainTableViewCell.swift
//  PryanikyTest
//
//  Created by Александр Сетров on 21.03.2021.
//

import UIKit

protocol MainTableViewCellSelectionDelegate: class {
    func selectedItem(with text: String)
    func setSelectedItemInfo(info: String)
}

class MainTableViewCell: UITableViewCell {
    var viewModel: MainCellViewModelProtocol?
    var cellView: MainCellView?
    var actionText: String?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if let action = self.viewModel?.actionBlock, selected {
            action(self.actionText ?? "sorry, data is lost")
        }
    }

    private func setCellData() {
        guard let cellData = self.viewModel?.cellDataStruct else { return }
        switch cellData.dataType {
        case .picture:
            self.viewModel?.cellImage = { [ weak self ] data in
                self?.cellView?.cellImage = data
            }
            self.viewModel?.cellText = {  [ weak self ] data in
                self?.cellView?.dataTitle = data
            }
            self.actionText = cellData.dataContent.text
        case .hz:
            self.viewModel?.cellText = { [ weak self ] data in
                self?.cellView?.dataTitle = data
            }
            self.actionText = cellData.dataContent.text
        case .selector:
            self.cellView?.cellSelectionDelegate = self
            self.viewModel?.cellSelector = { [ weak self ] data in
                self?.cellView?.cellSelectionItems = data
            }
        }
    }

    private func setupUI() {
        guard let cellData = self.viewModel?.cellDataStruct else { return }
        let view: MainCellView!
        switch cellData.dataType {
        case .hz:
            view = self.makeHzCellView()
        case .picture:
            view = self.makePictureCellView()
        case .selector:
            view = self.makeSelectionCellView()
        }
        if let cellView = self.cellView {
            cellView.removeFromSuperview()
            self.cellView = view
        }
        self.cellView = view
        self.contentView.addSubview(view)
        self.setupConstraints()
    }

    private func setupConstraints() {
        guard let view = self.cellView else { return }
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
}

extension MainTableViewCell {

    public func configure() {
        self.setSelected(false, animated: false)
        self.setupUI()
        self.setCellData()
    }

    private func makeHzCellView() -> HzCellView {
        let view = HzCellView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    private func makePictureCellView() -> PictureCellView {
        let view = PictureCellView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    private func makeSelectionCellView() -> SelectionCellView {
        let view = SelectionCellView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

extension MainTableViewCell: MainTableViewCellSelectionDelegate {
    func setSelectedItemInfo(info: String) {
        self.actionText = "selected \(info)"
    }

    func selectedItem(with text: String) {
        self.actionText = "selected \(text)"
        self.viewModel?.actionBlock?("selected \(text)")
    }

}
