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
        self.view.backgroundColor = .blue
        self.viewModel?.fetchData()
        // Do any additional setup after loading the view.
    }

    private func updateData() {
        self.viewModel?.updateMainData = { [ weak self ] data in
        }
    }
}
