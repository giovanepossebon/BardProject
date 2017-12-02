//
//  MasterSlideViewController.swift
//  BardProject
//
//  Created by Giovane Possebon on 2/12/17.
//  Copyright © 2017 bard. All rights reserved.
//

import UIKit

final class MasterSlideViewController: UIViewController {

    @IBOutlet weak var imgToShow: UIImageView!
    var slidesViewController: SlidesViewController!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        slidesViewController?.reloadData()
    }

    private func loadGif() {
        imgToShow.loadGif(name: "test")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let slidesVC = segue.destination as? SlidesViewController {
            slidesVC.delegate = self
            slidesVC.images = [#imageLiteral(resourceName: "tree1"), #imageLiteral(resourceName: "tree2"), #imageLiteral(resourceName: "tree3")]
        }
    }
}

extension MasterSlideViewController: SlidesDelegate {
    func didSelectSlideImage(image: UIImage) {
        imgToShow.image = image
    }
}
