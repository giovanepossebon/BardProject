//
//  UIView+Extension.swift
//  BardProject
//
//  Created by Giovane Possebon on 2/12/17.
//  Copyright © 2017 bard. All rights reserved.
//

import UIKit

extension UIView {

    func applyDropShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 20
        self.layer.masksToBounds = false
    }

    func applyRoundedBorder(corners: UIRectCorner) {
        self.layer.roundCorners(corners: corners, radius: 8)
    }

}


