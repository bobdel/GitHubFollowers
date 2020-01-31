//
//  GFFollowerItemViewController.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/24/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

class GFFollowerItemViewController: GFItemInfoViewController {

    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }

    // MARK: - Layout Methods

    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Git Followers")
    }

    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }

}
