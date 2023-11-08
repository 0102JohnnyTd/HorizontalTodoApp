//
//  ViewController.swift
//  HorizontalTodoApp
//
//  Created by Johnny Toda on 2023/11/07.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!

    /// DiffableDataSourceに渡すItemを管理
    private enum Item: Hashable {
        case todo(String)
    }

    // データソースに追加するSection
    private enum Section: Int, CaseIterable {
        case todoList

        // Sectionごとの列数を返す
        var columnCount: Int {
            switch self {
            case .todoList:
                return 1
            }
        }
    }

    /// アプリに表示させるドメインデータを要素とした配列
    private let todos = ["タスク1", "タスク2", "タスク3", "タスク4", "タスク5"]

    ///  CollectionViewに表示するデータを管理
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }

    // Cellのレイアウトを構築
    private func setUpCollectionView() {
        collectionView.delegate = self
        configureHierarchy()
    }
}

extension ViewController {
    private func configureHierarchy() {
        collectionView.collectionViewLayout = createLayout()
        // TodoCellを登録
        collectionView.register(TodoCell.self, forCellWithReuseIdentifier: TodoCell.identifier)
    }
}

// CollectionViewのLayoutを定義
extension ViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            // Sectionごとの列数を代入
            let columns = sectionKind.columnCount


            let section: NSCollectionLayoutSection

            switch sectionKind {
            case .todoList:
                // Itemのサイズを定義
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                // Itemを生成
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                // Itemの上下左右間隔を指定
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

                // Groupのサイズを定義
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalWidth(0.2))

                // Groupを生成
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               repeatingSubitem: item,
                                                               count: columns)
                // Sectionを生成
                section = NSCollectionLayoutSection(group: group)
                // Section間のスペース
                section.interGroupSpacing = 10
                // Scroll方向を指定
                section.orthogonalScrollingBehavior = .continuous
                // Sectionの上下左右間隔を指定
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

                return section
            }
        }
        return layout
    }
}

extension ViewController: UICollectionViewDelegate {}

