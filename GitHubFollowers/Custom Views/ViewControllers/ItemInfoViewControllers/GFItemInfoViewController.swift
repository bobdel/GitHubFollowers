//
//  GFItemInfoViewController.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/24/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

/// Superclass for the GFInfoViewControllers
class GFItemInfoViewController: UIViewController {

    // MARK: - Properties

    let stackView = UIStackView()
    let itemInfoViewOne = GFItemInfoView()
    let itemInfoViewTwo = GFItemInfoView()
    let actionButton = GFButton()

    var user: User!

    // MARK: - Initializers

    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackGroundView()
        layoutUI()
        configureStackView()
        configureActionButton()
    }

    // MARK: - Layout Methods

    private func configureBackGroundView() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }

    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing

        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
    }

    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }

    @objc func actionButtonTapped() { } // overridden by subclass for specific behavior

    private func layoutUI() {
        view.addSubviews(stackView, actionButton)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),

            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)

        ])
    }

}
