//
//  FactCoordinator.swift
//  chuck-facts
//
//  Created by Danilo Camarotto on 30/12/19.
//  Copyright © 2019 Danilo Camarotto. All rights reserved.
//

import UIKit

class FactCoordinator: Coordinator {
    
    private let presenter: UINavigationController
    private let viewModel: FactViewModel
    
    init(presenter: UINavigationController, category: Category) {
        self.presenter = presenter
        viewModel = FactViewModel(category)
    }
    
    func start() {
        let vc = instantiateViewController(named: FactViewController.viewIdentifier, from: "Main") as! FactViewController
        vc.viewModel = viewModel
        presenter.present(vc, animated: true)
    }
}
