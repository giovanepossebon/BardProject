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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadGif()
    }

    private func loadGif() {
        imgToShow.loadGif(name: "test")
    }
}
