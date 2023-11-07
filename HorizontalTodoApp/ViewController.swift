//
//  ViewController.swift
//  HorizontalTodoApp
//
//  Created by Johnny Toda on 2023/11/07.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }

    // Cellのレイアウトを構築
    private func setUpCollectionView() {
        collectionView.delegate = self
        configureHierarchy()
//        configureDataSource()
    }
}

extension ViewController {
    private func configureHierarchy() {
//        collectionView.collectionViewLayout = createLayout()
        // TodoCellを登録
        collectionView.register(TodoCell.self, forCellWithReuseIdentifier: TodoCell.identifier)
    }
}

extension ViewController: UICollectionViewDelegate {

}
