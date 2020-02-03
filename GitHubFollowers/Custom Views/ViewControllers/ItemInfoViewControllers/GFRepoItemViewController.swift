//
//  GFRepoItemViewController.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/24/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

// define protocol to message UserInfoViewController
// handles button taps on modal info screen
protocol GFRepoItemViewControllerDelegate: class {
    func didTapGitHubProfile(for user: User)
}

class GFRepoItemViewController: GFItemInfoViewController {

    // MARK: - Properties
    weak var delegate: GFRepoItemViewControllerDelegate!

    // MARK: - Initializers

    init(user: User, delegate: GFRepoItemViewControllerDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }

    // MARK: - Layout Methods

    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }

    // MARK: - Delegate Methods

    override func actionButtonTapped() {
        // note delegate set in configureUIElements() in UserInfoViewController
        delegate.didTapGitHubProfile(for: user)
    }

}
