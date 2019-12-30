//
//  Utils.swift
//  chuck-facts
//
//  Created by Danilo Camarotto on 30/12/19.
//  Copyright © 2019 Danilo Camarotto. All rights reserved.
//

import UIKit

func instantiateViewController(named name: String, from storyboard: String) -> UIViewController {
    let storyboard = UIStoryboard(name: storyboard, bundle: nil)
    let viewController = storyboard.instantiateViewController(identifier: name)
    return viewController
}
