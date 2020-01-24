//
//  GFRepoItemViewController.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/24/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

class GFRepoItemViewController: GFItemInfoViewController {
    
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
    
}
