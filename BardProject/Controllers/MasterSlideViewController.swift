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
    var suggestionsViewController: SuggestionsViewController!
    
    @IBOutlet weak var slidesContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var suggestionsTrailingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        slidesViewController?.reloadData()
    }

    private func loadGif() {
        imgToShow.loadGif(name: "test")
    }

    private func setupGestures() {
        let upGesture = UISwipeGestureRecognizer(target: self, action: #selector(showHistory))
        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideHistory))
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(showSuggestions))
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideSuggestions))
        upGesture.direction = .up
        downGesture.direction = .down
        leftGesture.direction = .left
        rightGesture.direction = .right
        view.addGestureRecognizer(upGesture)
        view.addGestureRecognizer(downGesture)
        view.addGestureRecognizer(leftGesture)
        view.addGestureRecognizer(rightGesture)
    }

    func shouldShowHistory(_ show: Bool) {
        slidesContainerBottomConstraint.constant = show ? 0.0 : 80.0
        animateGestures()
    }

    func shouldShowSuggestions(_ show: Bool) {
        suggestionsTrailingConstraint.constant = show ? 0.0 : 120.0
        animateGestures()
    }

    func animateGestures() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func showHistory() {
        shouldShowHistory(true)
    }

    @objc func hideHistory() {
        shouldShowHistory(false)
    }

    @objc func showSuggestions() {
        shouldShowSuggestions(true)
    }

    @objc func hideSuggestions() {
        shouldShowSuggestions(false)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let slidesVC = segue.destination as? SlidesViewController {
            slidesViewController = slidesVC
            slidesVC.delegate = self
            slidesVC.images = [#imageLiteral(resourceName: "tree1"), #imageLiteral(resourceName: "tree2"), #imageLiteral(resourceName: "tree3")]
        }
        if let suggestionsVC = segue.destination as? SuggestionsViewController {
            suggestionsViewController = suggestionsVC
            suggestionsVC.delegate = self
            suggestionsVC.images = [#imageLiteral(resourceName: "tree1"), #imageLiteral(resourceName: "tree2"), #imageLiteral(resourceName: "tree3")]
        }
    }
}

extension MasterSlideViewController: SlidesDelegate {
    func didSelectSlideImage(image: UIImage) {
        imgToShow.image = image
    }
}

extension MasterSlideViewController: SuggestionsDelegate {
    func didSelectSuggestionImage(image: UIImage) {
        imgToShow.image = image
        slidesViewController.add(image)
    }
}
