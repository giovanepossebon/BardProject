//
//  SuggestionsViewController.swift
//  BardProject
//
//  Created by Carlos Corrêa on 02/12/17.
//  Copyright © 2017 bard. All rights reserved.
//

import UIKit

protocol SuggestionsDelegate: class {
    func didSelectSuggestionImage(image: UIImage)
}

class SuggestionsViewController: UIViewController {

    static let identifier = "SuggestionsDelegate"

    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: SuggestionsDelegate?

    internal var images: [UIImage] = [] {
        didSet {
            if let collection = collectionView {
                collection.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.register(UINib(nibName: SuggestionCell.identifier, bundle: nil), forCellWithReuseIdentifier: SuggestionCell.identifier)
    }

    func reloadData() {
        collectionView.reloadData()
    }

    func setup(with images: [UIImage]) {
        self.images = images
    }
}

extension SuggestionsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionCell.identifier, for: indexPath) as? SuggestionCell else { return UICollectionViewCell() }

        let slide = images[indexPath.row]
        cell.populate(with: slide)

        return cell
    }
}

extension SuggestionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.row]
        delegate?.didSelectSuggestionImage(image: image)
    }
}
