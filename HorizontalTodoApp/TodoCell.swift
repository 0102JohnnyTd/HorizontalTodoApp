//
//  TodoCell.swift
//  HorizontalTodoApp
//
//  Created by Johnny Toda on 2023/11/07.
//

import UIKit

final class TodoCell: UICollectionViewCell {
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    static let nib = UINib(nibName: String(describing: TodoCell.self), bundle: nil)
    static let identifier = String(describing: TodoCell.self)

    // ⚠️この時点ではCellのサイズは決定していない為、awakeFromNib内でレイアウトの設定は避けるべき。
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpBackgroundView()
    }

    // 💡呼び出し時点で制約が確定しており、その制約をもとにViewのレイアウトを実行する
    override func layoutSubviews() {
        // Viewを円形にする
        iconView.layer.cornerRadius = iconView.frame.width * 0.5
        iconView.frame.size = CGSize(width: self.frame.width, height: self.frame.height * 0.9)
        nameLabel.frame.size = CGSize(width: self.frame.width, height: self.frame.height * 0.1)
        // backgroundViewのViewからはみ出た部分などを非表示にする
//        self.layer.masksToBounds = true
    }

    ///  BackgroundViewを生成する
    private func setUpBackgroundView() {
        backgroundView = UIView(frame: super.frame)
        backgroundView?.backgroundColor = .systemBackground
    }

    /// 自身のオブジェクトに値を代入する
    func configure(name: String?) {
        iconView.image = UIImage(named: "Icon")
        nameLabel.text = name
    }
}
