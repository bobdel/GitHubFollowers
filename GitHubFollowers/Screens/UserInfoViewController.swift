//
//  UserInfoViewController.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/15/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit
import SafariServices

// define protocol for this file's viewController
protocol UserInfoViewControllerDelegate: class {
    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

class UserInfoViewController: UIViewController {
    
    // MARK: - Containers
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []
    
    // MARK: - Properties
    
    var username: String!

    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()

        getUserInfo()
    }
    
    // MARK: - Helper Functions
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async { self.configureUIElements(with: user) }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureUIElements(with user: User) {
        
        let repoItemViewController = GFRepoItemViewController(user: user)
        repoItemViewController.delegate = self
        
        let followerItemViewController = GFFollowerItemViewController(user: user)
        followerItemViewController.delegate = self
        
        self.add(childVC: repoItemViewController, to: self.itemViewOne)
        self.add(childVC: followerItemViewController, to: self.itemViewTwo)
        self.add(childVC: GFUserInfoHeaderViewController(user: user), to: self.headerView)
        self.dateLabel.text = " GitHub since \(user.createdAt.convertToDisplayFormat())"
    }
    
    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140

        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel ]

        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ])
        }
        
                
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),

            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),

            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
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

// managing the button taps on this controller. Protocol conformance
extension UserInfoViewController: UserInfoViewControllerDelegate {
    func didTapGitHubProfile(for user: User) {
        print("didTapGitHubProfile")
        // show safari view controller
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user in invalid.", buttonTitle: "Ok")
            return
        }
        
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = .systemGreen
        present(safariViewController, animated: true)
    }
    
    func didTapGetFollowers(for user: User) {
        print("didTapGGetFollowers")
        // dismiss this vc then update follower list screen with new user
    }
    
}
