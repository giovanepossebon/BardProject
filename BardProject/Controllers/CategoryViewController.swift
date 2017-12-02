//
//  ViewController.swift
//  BardProject
//
//  Created by Giovane Possebon on 2/12/17.
//  Copyright © 2017 bard. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var categories: [Category]? {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        loadCategories()
    }

    private func setupCollectionView() {
        collectionView.register(UINib(nibName: CategoryCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoryCell.identifier)
    }

    private func loadCategories() {
        CategoryService.getCategories { categories in
            switch categories.result {
            case .success:
                guard let result = categories.data else { return }
                self.categories = result
            case .error(message: let error):
                print(error)
            }
        }
    }

}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell {

            guard let category = categories?[indexPath.row] else { return UICollectionViewCell() }
            cell.populate(with: category)

            return cell
        }

        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

}
