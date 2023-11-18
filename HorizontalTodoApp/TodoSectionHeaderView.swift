//
//  TodoSectionHeaderView.swift
//  HorizontalTodoApp
//
//  Created by Johnny Toda on 2023/11/12.
//

import UIKit

final class TodoSectionHeaderView: UICollectionReusableView {
    @IBOutlet private weak var nameLabel: UILabel!
    
    // xibやstoryboardではないクラスインスタンスが生成された場合に呼ばれる
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // xibやstoryboardからインスタンス生成される場合に呼ばれる
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static let nib = UINib(nibName: String(describing: TodoSectionHeaderView.self), bundle: nil)
    static let identifier = String(describing: TodoSectionHeaderView.self)

    func configure(name: String) {
        nameLabel.text = name
    }
}
