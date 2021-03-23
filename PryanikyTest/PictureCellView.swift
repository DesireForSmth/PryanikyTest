//
//  PictureCellView.swift
//  PryanikyTest
//
//  Created by Александр Сетров on 23.03.2021.
//

import UIKit

class PictureCellView: MainCellView {

    override var dataTitle: String? {
        didSet {
            if let title = dataTitle {
                self.setNeedsLayout()
                self.label.text = title
                self.layoutIfNeeded()
            }
        }
    }

    override var cellImage: UIImage? {
        didSet {
            if let image = cellImage {
                self.setNeedsLayout()
                let frame = CGRect(x: 0, y: 0, width: Constants.imageSize, height: Constants.imageSize)
                UIGraphicsBeginImageContext(CGSize(width: frame.width, height: frame.height))
                image.draw(in: frame)
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                self.imageView.image = newImage
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

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private func setupUI() {
        self.addSubview(label)
        self.addSubview(imageView)
        self.setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.inset),
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.inset),
            self.label.trailingAnchor.constraint(equalTo: self.imageView.leadingAnchor, constant: -Constants.inset),

            self.imageView.topAnchor.constraint(equalTo: self.label.topAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.inset),
            self.imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            self.imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),

            self.bottomAnchor.constraint(greaterThanOrEqualTo: self.imageView.bottomAnchor, constant: Constants.inset),
            self.bottomAnchor.constraint(greaterThanOrEqualTo: self.label.bottomAnchor, constant: Constants.inset)
        ])
    }
}
