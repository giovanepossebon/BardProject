//
//  SuggestionCell.swift
//  BardProject
//
//  Created by Carlos Corrêa on 02/12/17.
//  Copyright © 2017 bard. All rights reserved.
//

import UIKit

class SuggestionCell: UICollectionViewCell {

    static let identifier = String(describing: SuggestionCell.self)

    @IBOutlet weak var slideImage: UIImageView!

    func populate(with image: UIImage) {
        slideImage.image = image
    }
}
