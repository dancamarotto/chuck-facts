//
//  ApplicationCoordinator.swift
//  chuck-facts
//
//  Created by Danilo Camarotto on 30/12/19.
//  Copyright © 2019 Danilo Camarotto. All rights reserved.
//

import UIKit

class ApplicationCoordinator: Coordinator {
    
    private let window: UIWindow
    private let rootViewController: UINavigationController
    private let categoriesListCoordinator: CategoriesListCoordinator
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        categoriesListCoordinator = CategoriesListCoordinator(presenter: rootViewController)
    }
    
    func start() {
        window.rootViewController = rootViewController
        categoriesListCoordinator.start()
        window.makeKeyAndVisible()
    }
}
