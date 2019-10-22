//
//  CategoryTableViewCell.swift
//  chuck-facts
//
//  Created by Danilo Camarotto on 21/10/19.
//  Copyright © 2019 Danilo Camarotto. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var genreLabel: UILabel!
    
    static let identifier = "CategoryCell"
    
    func setup(_ genre: Category) {
        genreLabel.text = genre.name
    }
}
