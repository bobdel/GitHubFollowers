//
//  GFFollowerItemViewController.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/24/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

protocol GFFollowerItemViewControllerDelegate: AnyObject {
    func didTapGetFollowers(for user: User)
}

class GFFollowerItemViewController: GFItemInfoViewController {

    // MARK: - Properties

    weak var delegate: GFFollowerItemViewControllerDelegate!

    // MARK: - Initializers

    init(user: User, delegate: GFFollowerItemViewControllerDelegate) {
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
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(color: .systemGreen, title: "Git Followers", systemImageName: "person.3")
    }

    // MARK: - Delegate Methods

    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }

}
