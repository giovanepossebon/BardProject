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
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = .zero
        layer.shadowRadius = 20
        layer.masksToBounds = false
    }

    func applyRoundedBorder(corners: UIRectCorner) {
        layer.roundCorners(corners: corners, radius: 8)
    }

    func applyCircleFormat() {
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
    }
}


