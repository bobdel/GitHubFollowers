//
//  UserInfoViewController.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/15/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit
import os.log

// MARK: - Protocol

/// call a method on FollowerListViewController to dismiss a VC
protocol UserInfoViewControllerDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

// MARK: - UIViewController

class UserInfoViewController: UIViewController {

    // MARK: - Properties

    let scrollView = UIScrollView()
    let scrollContentView = UIView()

    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []

    var username: String!
    weak var delegate: UserInfoViewControllerDelegate!

    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("viewDidLoad UserInfoVC", log: Log.general, type: .info)
        configureViewController()
        configureScrollView()
        layoutUI()

        getUserInfo()
    }

    // MARK: - Layout Methods

    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
    }

    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollView.pinToEdges(of: view)
        scrollContentView.pinToEdges(of: scrollView)

        NSLayoutConstraint.activate([
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollContentView.heightAnchor.constraint(equalToConstant: 620)
        ])

    }

    func getUserInfo() {
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                self.configureUIElements(with: user)
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlertOnMainThread(
                        title: "Something went wrong.",
                        message: gfError.rawValue,
                        buttonTitle: "Ok"
                    )
                } else {
                    presentDefaultError()
                }
            }
        }
    }

    func configureUIElements(with user: User) {

        add(childVC: GFRepoItemViewController(user: user, delegate: self), to: itemViewOne)
        add(childVC: GFFollowerItemViewController(user: user, delegate: self), to: itemViewTwo)
        add(childVC: GFUserInfoHeaderViewController(user: user), to: headerView)
        dateLabel.text = " GitHub since \(user.createdAt.convertToMonthYearFormat())"
    }

    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140

        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel ]

        for itemView in itemViews {
            scrollContentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -padding)
            ])
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),

            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),

            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),

            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])

    }

    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }

    @objc func dismissViewController() {
        dismiss(animated: true)
    }

}

// MARK: - Extensions (Delegate Conformance)

extension UserInfoViewController: GFRepoItemViewControllerDelegate {

    func didTapGitHubProfile(for user: User) {
        // show safari view controller
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL",
                                       message: "The url attached to this user in invalid.",
                                       buttonTitle: "Ok")
            return
        }
        presentSafariViewController(with: url)
    }
}

extension UserInfoViewController: GFFollowerItemViewControllerDelegate {

    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No Followers",
                                       message: "This user has no followers.",
                                       buttonTitle: "Ok")
            return
                }
                delegate.didRequestFollowers(for: user.login)
                dismissViewController()
                // dismiss this vc then update follower list screen with new user
    }
}
