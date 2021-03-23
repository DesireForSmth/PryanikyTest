//
//  SelectionCellView.swift
//  PryanikyTest
//
//  Created by Александр Сетров on 23.03.2021.
//

import UIKit

class SelectionCellView: MainCellView {

    var selectedButton: UIButton?

    override var cellSelectionItems: [SelectionItem]? {
        didSet {
            guard let items = cellSelectionItems else { return }
            self.setNeedsLayout()
            self.cellSelectionDelegate?.setSelectedItemInfo(info: "none")
            items.forEach {
                let button = UIButton(type: .system)
                button.setTitle($0.text, for: .normal)
                if $0.isSelected {
                    button.tintColor = .red
                    self.selectedButton = button
                    self.cellSelectionDelegate?.setSelectedItemInfo(info: $0.text)
                } else {
                    button.tintColor = .gray
                }
                button.addTarget(self, action: #selector(self.pickButton), for: .touchUpInside)
                self.vStack.addArrangedSubview(button)
            }
            self.layoutIfNeeded()
        }
    }

    @objc private func pickButton(_ sender: UIButton) {
        self.selectedButton?.tintColor = .gray
        sender.tintColor = .red
        self.selectedButton = sender
        self.cellSelectionDelegate?.selectedItem(with: sender.title(for: .normal) ?? "Sorry, data lost")
    }

    lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = CGFloat(10)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.addSubview(vStack)
        self.setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.vStack.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.inset),
            self.vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.inset),
            self.vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.inset),
            self.vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.inset)
        ])
    }
}
