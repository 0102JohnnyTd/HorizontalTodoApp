//
//  ViewController.swift
//  HorizontalTodoApp
//
//  Created by Johnny Toda on 2023/11/07.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!

    @IBOutlet private weak var addTodoButton: UIButton!

    @IBAction private func didTapAddTodoButton(_ sender: Any) {
        print("ボタンのサイズ：", addTodoButton.frame.size)
        showAddTodoVC()
    }

    /// DiffableDataSourceに渡すItemを管理
    private enum Item: Hashable {
        case todo(String)
    }

    // データソースに追加するSection
    private enum Section: Int, CaseIterable {
        case todoList
        case timeLine

        // Sectionごとの列数を返す
        var columnCount: Int {
            switch self {
            case .todoList:
                return 1
            case .timeLine:
                return 1
            }
        }
    }

    /// アプリに表示させるドメインデータを要素とした配列
    private var todoList = ["タスク1", "タスク2", "タスク3", "タスク4", "タスク5"]
    /// アプリに表示させるドメインデータを要素とした配列
    private var timelineContentList = ["ゴリラに水やり", "トマトにバナナあげる"]

    ///  CollectionViewに表示するデータを管理
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        configureButton()
        applyInitialSnapshots(todos: todoList)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addTodoButton.layer.cornerRadius = addTodoButton.frame.width * 0.5
    }

    /// ボタンのUIを構築
    private func configureButton() {
        addTodoButton.backgroundColor = .green
        addTodoButton.layer.masksToBounds = true
    }

    /// Cellのレイアウトを構築
    private func setUpCollectionView() {
        collectionView.delegate = self
        configureHierarchy()
        configureDataSource()
    }

    /// タスク追加画面を表示する
    private func showAddTodoVC() {
        let addTodoVC = UIStoryboard(name: AddTodoViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: AddTodoViewController.identifier) as! AddTodoViewController

        addTodoVC.completion = { [weak self] text in
            guard let strongSelf = self else { return }
            strongSelf.todoList.append(text)
            strongSelf.applyTodoSnapshot(todoList: strongSelf.todoList)
        }

        present(addTodoVC, animated: true)
    }
}

extension ViewController {
    /// CollectionViewに設定したレイアウトを適用させる
    private func configureHierarchy() {
        collectionView.collectionViewLayout = createLayout()
    }

    /// Datasourceを構築
    private func configureDataSource() {
        // TodoCellの登録
        let todoCellRegistration = UICollectionView.CellRegistration<TodoCell, Item>(cellNib: TodoCell.nib) { cell, _, item in
            switch item {
            case .todo(let todo):
                cell.layer.cornerRadius = cell.frame.width * 0.5
                cell.configure(name: todo)
            }
        }

        // TimeLineCellの登録
        let timeLineCellRegistration = UICollectionView.CellRegistration<TimeLineCell, Item>(cellNib: TimeLineCell.nib) { cell, _, item in
            switch item {
            case .todo(let todo):
                cell.configure(todo: todo)
            }
        }

        // dataSourceの構築
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .todoList:
                return collectionView.dequeueConfiguredReusableCell(
                    using: todoCellRegistration,
                    for: indexPath,
                    item: item
                )
            case .timeLine:
                return collectionView.dequeueConfiguredReusableCell(
                    using: timeLineCellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        })
    }
}

// CollectionViewのLayoutを定義
extension ViewController {
    /// CollectionViewのレイアウトを構築する
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            // Sectionごとの列数を代入
            let columns = sectionKind.columnCount


            let section: NSCollectionLayoutSection

            switch sectionKind {
            case .todoList:
                // Itemのサイズを定義
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.2))
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
            case .timeLine:
                // Itemのサイズを定義
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                // Itemを生成
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                // Itemの上下左右間隔を指定
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 4, bottom: 4, trailing: 4)

                // Groupのサイズを定義
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
                // Groupを生成
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               repeatingSubitem: item,
                                                               count: columns)

                // Sectionを生成
                section = NSCollectionLayoutSection(group: group)
                // Section間のスペース
                section.interGroupSpacing = 10
                // Sectionの上下左右間隔を指定
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

                return section
            }
        }
        return layout
    }
}

extension ViewController {
    /// アプリ起動時にデータを適用する
    private func applyInitialSnapshots(todos: [String]) {
        // データをViewに反映させる為のDiffableDataSourceSnapshotクラスのインスタンスを生成
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

        // snapshotにSectionを追加
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot)

        // dataSourceに適応させるSectionSnapshotのインスタンスを生成
        var todoSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        // String型の値をItem型に変換した配列を生成
        let todoItems = todos.map { Item.todo($0) }
        // Item型に変換したtodosを生成したSnapshotに追加
        todoSnapshot.append(todoItems)
        // snapshotをdataSourceに適用し、todoListに追加
        dataSource.apply(todoSnapshot, to: .todoList, animatingDifferences: true)

        var timeLineItemSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        let timelineItems = timelineContentList.map { Item.todo($0) }
        timeLineItemSnapshot.append(timelineItems)
        dataSource.apply(timeLineItemSnapshot, to: .timeLine, animatingDifferences: true)
    }
    /// Todoセクションのデータを更新する
    private func applyTodoSnapshot(todoList: [String]) {
        var snapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        let todoItems = todoList.map { Item.todo($0) }

        snapshot.append(todoItems)
        dataSource.apply(snapshot, to: .todoList, animatingDifferences: true)
    }

    /// タイムラインセクションのデータを更新する
    private func applyTimeLineSnapshot(timelineContents: [String]) {
        var snapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        let timeLineItems = timelineContents.map { Item.todo($0) }

        snapshot.append(timeLineItems)
        dataSource.apply(snapshot, to: .timeLine, animatingDifferences: true)
    }
}

extension ViewController {
    /// タップしたCellを削除する
    private func clearTodo(todo: String, completion: () -> Void) {
        todoList.removeAll { $0.contains(todo) }
        applyTodoSnapshot(todoList: todoList)
        completion()
    }

    ///  完了したタスクをリストの最上部に表示させる
    private func addTimeLineContent(todo: String) {
        timelineContentList.insert(todo, at: 0)
        applyTimeLineSnapshot(timelineContents: timelineContentList)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionKind = Section(rawValue: indexPath.section) else { return }

        switch sectionKind {
        case .todoList:
            guard let listItem = dataSource.itemIdentifier(for: indexPath) else { return }

            switch listItem {
            case .todo(let todo):
                clearTodo(todo: todo) {
                    addTimeLineContent(todo: todo)
                }
            }
        case .timeLine:
            print("Did tap timeLineCell.")
        }
    }
}

