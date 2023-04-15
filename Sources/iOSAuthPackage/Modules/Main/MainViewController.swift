//
//  MainViewController.swift
//  SetiAuth
//
//  Created by Arseniy Matus on 10.03.2023.
//
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
        setupUI()
    }

    // MARK: - Properties

    var presenter: ViewToPresenterMainProtocol?

    // MARK: - Functions

    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
}

extension MainViewController: PresenterToViewMainProtocol {
    func setupSuccessAlert(isAdmin: Bool, with info: [Info]) {
        let title = isAdmin ? "Админ 👑" : "Обычный 😕"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        for user in info {
            let action = UIAlertAction(title: "\(user.label)\n\(user.amount)", style: .default)
            action.isEnabled = false
            alert.addAction(action)
        }
        UILabel.appearance(whenContainedInInstancesOf:[UIAlertController.self]).numberOfLines = 0

        alert.addAction(UIAlertAction(title: "Готово", style: .cancel, handler: { _ in
            self.presenter?.exit()
        }))
        self.present(alert, animated: true)
    }

    func setupErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Готово", style: .destructive, handler: { _ in
            self.presenter?.exit()
        }))
        self.present(alert, animated: true)
    }
}
