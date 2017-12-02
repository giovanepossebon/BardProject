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

    static let identifier = "CategoryCell"

    @IBOutlet weak var categoryImage: UIImageView! {
        didSet {
            categoryImage.applyCircleFormat()
        }
    }

    @IBOutlet weak var categoryTitle: UILabel!

    func populate(with category: Category) {
        categoryTitle.text = category.title
        categoryImage.backgroundColor = .purple
        categoryImage.af_setImage(withURL: category.imageUrl)
    }

}
