//
//  SearchViewController.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/9/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit
import os.log

class SearchViewController: UIViewController {

    // MARK: - Properties

    let logoImageView = UIImageView()
    let usernameTextField = GFTextField()
    let callToActionButton = GFButton(color: .systemGreen, title: "Get Followers", systemImageName: "person.3")

    var isUsernameEntered: Bool { !usernameTextField.text!.isEmpty }

    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("viewDidLoad SearchVC", log: Log.general, type: .info)
        view.backgroundColor = .systemBackground
        view.addSubviews(logoImageView, usernameTextField, callToActionButton)
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        usernameTextField.text = ""
                #if DEBUG
                usernameTextField.text! = "SAllen0400"
                #endif

        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Helper Methods

    @objc func pushFollowerListViewController() {

        guard isUsernameEntered else {
            presentGFAlertOnMainThread(title: "Empty Username",
                                       message: "Please enter a username. We need to know who to look for 😃!",
                                       buttonTitle: "Ok")
            return
        }

        usernameTextField.resignFirstResponder() // fixes overlap with slide gesture

        let followerListVC = FollowerListViewController(username: usernameTextField.text!)
        navigationController?.pushViewController(followerListVC, animated: true)
    }

    // MARK: configure subviews

    private func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo

        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                               constant: topConstraintConstant),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func configureTextField() {
        usernameTextField.delegate = self

        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func configureCallToActionButton() {
        callToActionButton.addTarget(self, action: #selector(pushFollowerListViewController), for: .touchUpInside)

        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: handle keyboard

    /// tapping anywhere on screen dismisses keyboard
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}

// MARK: - Extensions

/// UITextFieldDelegate Conformance
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListViewController()
        return true
    }
}
