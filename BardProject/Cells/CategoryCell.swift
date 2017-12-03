//
//  CategoryCell.swift
//  BardProject
//
//  Created by Giovane Possebon on 2/12/17.
//  Copyright © 2017 bard. All rights reserved.
//

import UIKit
import AlamofireImage

class CategoryCell: UICollectionViewCell {

    static let identifier = String(describing: CategoryCell.self)

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            }
        }
    }

    @IBOutlet weak var categoryImage: UIImageView! {
        didSet {
            categoryImage.applyRoundedBorder(corners: [.allCorners])
        }
    }

    @IBOutlet weak var categoryTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        applyDropShadow()
    }

    func populate(with category: Category) {
        categoryTitle.text = category.title.uppercased()
        categoryImage.af_setImage(withURL: category.imageUrl)
    }
}
