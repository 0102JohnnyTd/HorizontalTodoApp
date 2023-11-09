//
//  AddTodoViewController.swift
//  HorizontalTodoApp
//
//  Created by Johnny Toda on 2023/11/09.
//

import UIKit

final class AddTodoViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!

    @IBAction private func didTapAddTodoButton(_ sender: Any) {
        addTodo()
    }
    static let storyboardName = "AddTodo"
    static let identifier = "AddTodo"

    // 遷移元から処理を受け取るクロージャのプロパティを用意
    var completion: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func addTodo() {
        if let completion = self.completion {
            if let text = textField.text {
                // 入力値を引数として渡された処理の実行
                completion(text)
            }
        }
        // 遷移元へ戻る
        self.dismiss(animated: true, completion: nil)
    }
}
