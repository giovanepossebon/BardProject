//
//  SlidesViewController.swift
//  BardProject
//
//  Created by Carlos Corrêa on 02/12/17.
//  Copyright © 2017 bard. All rights reserved.
//

import UIKit

protocol SlidesDelegate: class {
    func didSelectSlideImage(image: UIImage)
}

class SlidesViewController: UIViewController {

    static let identifier = "SlidesViewController"

    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: SlidesDelegate?

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
        collectionView.register(UINib(nibName: SlideCell.identifier, bundle: nil), forCellWithReuseIdentifier: SlideCell.identifier)
    }

    func reloadData() {
        collectionView.reloadData()
    }

    func setup(with images: [UIImage]) {
        self.images = images
    }
}

extension SlidesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlideCell.identifier, for: indexPath) as? SlideCell else { return UICollectionViewCell() }

        let slide = images[indexPath.row]
        cell.populate(with: slide)

        return cell
    }
}

extension SlidesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.row]
        delegate?.didSelectSlideImage(image: image)
    }
}
