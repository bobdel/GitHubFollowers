//
//  FavoritesListViewController.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/9/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

class FavoritesListViewController: UIViewController {
    
    // MARK: properties
    
    
    // MARK: viewcontroller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        
        PersistenceManager.retrieveFavorites {  result in
            switch result {
            case .success(let favorites):
                print(favorites)
            case .failure(let error):
                break
            }
        }
    
    // MARK: private methods

}
}
