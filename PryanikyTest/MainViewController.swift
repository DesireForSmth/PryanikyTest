//
//  MainViewController.swift
//  PryanikyTest
//
//  Created by Александр Сетров on 20.03.2021.
//

import UIKit

class MainViewController: UIViewController {

    var viewModel: MainViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.updateData()
        self.viewModel?.fetchData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(tableView)
        self.setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

    private func updateData() {
        self.viewModel?.updateDataState = { [ weak self ] state in
            switch state {
            case .initial:
                self?.activityIndicatorView.stopAnimating()
                self?.activityIndicatorView.isHidden = true
            case .loading:
                self?.activityIndicatorView.startAnimating()
                self?.activityIndicatorView.isHidden = false
            case .failure:
                self?.activityIndicatorView.stopAnimating()
                self?.activityIndicatorView.isHidden = true
                self?.makeDownloadAlerAction()
            case .success:
                self?.activityIndicatorView.stopAnimating()
                self?.activityIndicatorView.isHidden = true
                self?.tableView.reloadData()
            }
        }
    }

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView()
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = UITableView.automaticDimension
        table.register(MainTableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    lazy var activityIndicatorView:  UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        return activityIndicator
    }()

    private func makeDownloadAlerAction() {
        let alert = UIAlertController(title: "Download error", message: "Try later", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    private func showCellInfo(name: String) {
        let alert = UIAlertController(title: "Cell Info", message: "name: \(name)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.getCellModels().count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        guard let mainCell = cell as? MainTableViewCell else { return cell }
        guard let cellModel = self.viewModel?.getCellModels()[indexPath.row] as? MainCellViewModel else { return mainCell }
        cellModel.actionBlock = { [ weak self ] data in
            self?.showCellInfo(name: data)
            mainCell.setSelected(false, animated: true)
        }
        cellModel.shouldLayoutTableView = { [ weak self ] in
            self?.tableView.layoutIfNeeded()
        }
        mainCell.viewModel = cellModel
        mainCell.configure()
        return mainCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
