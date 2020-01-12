//
//  FollowerListViewController.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/10/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

class FollowerListViewController: UIViewController {

    // MARK: properties
    
    var username: String!
    
    // MARK: viewcontroller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        NetworkManager.shared.getFollowers(for: username, page: 1) { result in
            
            switch result {
            case .success(let followers):
                print(followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    // MARK: methods


}
