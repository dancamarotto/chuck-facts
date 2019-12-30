//
//  CategoriesListCoordinator.swift
//  chuck-facts
//
//  Created by Danilo Camarotto on 30/12/19.
//  Copyright © 2019 Danilo Camarotto. All rights reserved.
//

import UIKit

class CategoriesListCoordinator: Coordinator {
    
    private let presenter: UINavigationController
    private var factCoordinator: FactCoordinator?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func start() {
        let vc = instantiateViewController(named: CategoriesListViewController.viewIdentifier,
                                           from: "Main") as! CategoriesListViewController
        vc.delegate = self
        presenter.pushViewController(vc, animated: true)
    }
}

extension CategoriesListCoordinator: CategoriesListViewControllerDelegate {
    func didSelectCategory(_ category: Category) {
        let factCoordinator = FactCoordinator(presenter: presenter, category: category)
        factCoordinator.start()
        self.factCoordinator = factCoordinator
    }
}
