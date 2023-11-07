//
//  TodoCell.swift
//  HorizontalTodoApp
//
//  Created by Johnny Toda on 2023/11/07.
//

import UIKit

final class TodoCell: UICollectionViewCell {
    @IBOutlet private weak var nameLabel: UILabel!

    static let nib = UINib(nibName: String(describing: TodoCell.self), bundle: nil)
    static let identifier = String(describing: TodoCell.self)


    override func awakeFromNib() {
        super.awakeFromNib()
        setUpBackgroundView()
    }

    ///  BackgroundViewを生成する
    private func setUpBackgroundView() {
        backgroundView = UIView(frame: super.frame)
        backgroundView?.backgroundColor = .red
        backgroundView?.layer.cornerRadius = self.frame.width * 0.5
    }

    /// 自身のオブジェクトに値を代入する
    func configure(name: String?) {
        nameLabel.text = name
    }
}
