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

    func addParallaxMotionEffects(tiltValue : CGFloat = 0.25, panValue: CGFloat = 5) {

        var xTilt = UIInterpolatingMotionEffect()
        var yTilt = UIInterpolatingMotionEffect()

        var xPan = UIInterpolatingMotionEffect()
        var yPan = UIInterpolatingMotionEffect()

        let motionGroup = UIMotionEffectGroup()

        xTilt = UIInterpolatingMotionEffect(keyPath: "layer.transform.rotation.y", type: .tiltAlongHorizontalAxis)
        xTilt.minimumRelativeValue = -tiltValue
        xTilt.maximumRelativeValue = tiltValue

        yTilt = UIInterpolatingMotionEffect(keyPath: "layer.transform.rotation.x", type: .tiltAlongVerticalAxis)
        yTilt.minimumRelativeValue = -tiltValue
        yTilt.maximumRelativeValue = tiltValue

        xPan = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xPan.minimumRelativeValue = -panValue
        xPan.maximumRelativeValue = panValue

        yPan = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yPan.minimumRelativeValue = -panValue
        yPan.maximumRelativeValue = panValue

        motionGroup.motionEffects = [xTilt]
        self.addMotionEffect( motionGroup )
    }

}


