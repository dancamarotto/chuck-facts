//
//  CategoryTableViewCell.swift
//  chuck-facts
//
//  Created by Danilo Camarotto on 21/10/19.
//  Copyright © 2019 Danilo Camarotto. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    static let identifier = "CategoryCell"
    
    func setup(_ category: Category) {
        categoryLabel.text = category.name
    }
}
