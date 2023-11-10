//
//  TimeLineCell.swift
//  HorizontalTodoApp
//
//  Created by Johnny Toda on 2023/11/10.
//

import UIKit

final class TimeLineCell: UICollectionViewCell {
    @IBOutlet private weak var descriptionLabel: UILabel!

    static let nib = UINib(nibName: String(describing: TimeLineCell.self), bundle: nil)
    static let identifier = String(describing: TimeLineCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpBackgroundView()
    }

    private func setUpBackgroundView() {
        backgroundView = UIView(frame: super.frame)
        backgroundView?.backgroundColor = .systemGray6
    }

    func  configure(todo: String) {
        descriptionLabel.text = "『\(todo)』を完了しました"
    }
}
