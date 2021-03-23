//
//  HzCellView.swift
//  PryanikyTest
//
//  Created by Александр Сетров on 23.03.2021.
//

import UIKit

class HzCellView: MainCellView {

    override var dataTitle: String? {
        didSet {
            if let title = dataTitle {
                self.setNeedsLayout()
                self.label.text = title
                self.layoutIfNeeded()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private func setupUI() {
        self.addSubview(label)
        self.setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.inset),
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.inset),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.inset),

            self.bottomAnchor.constraint(equalTo: self.label.bottomAnchor, constant: Constants.inset)
        ])
    }

}
