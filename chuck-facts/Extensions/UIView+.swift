//
//  UIView+.swift
//  chuck-facts
//
//  Created by Danilo Camarotto on 22/10/19.
//  Copyright © 2019 Danilo Camarotto. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable
    /// Used to round the views border.
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
