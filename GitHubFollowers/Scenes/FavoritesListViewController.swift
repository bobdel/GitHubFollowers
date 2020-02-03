//
//  FavoritesListViewController.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/9/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

class FavoritesListViewController: GFDataLoadingViewController {

    // MARK: - Properties

    let tableView = UITableView()
    var favorites: [Follower] = []

    // MARK: - Viewcontroller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }

    // MARK: - Layout methods

    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells()

        // register cell with tableView
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }

    func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let favorites): // RESULT SUCCESS
                self.updateUI(with: favorites)

            case .failure(let error): // RESULT ERROR
                self.presentGFAlertOnMainThread(title: "Something went wrong",
                                                message: error.rawValue,
                                                buttonTitle: "Ok")
            }
        }
    }

    func updateUI(with favorites: [Follower]) {
        // check for empty state
        if favorites.isEmpty {
            self.showEmptyStateView(with: "No Favorites?\nAdd one on the Follower screen", in: self.view)
        } else {
            self.favorites = favorites
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView) // edge case to avoid issues if empty state
            }
        }
    }
}

// MARK: - Extension (Data Source)

/// entire data source
extension FavoritesListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        // swiftlint:enable force_cast
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }

    // didselectrow - show followers from selected favorite
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destinationViewController = FollowerListViewController(username: favorite.login)

        navigationController?.pushViewController(destinationViewController, animated: true)
    }

    // delete favorite
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        // remove from persistent array
        PersistenceManager.updateWith(favorite: favorites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }

            guard let error = error else { // if the deletion was successful
                // remove from array local to self
                self.favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                return
            }

            self.presentGFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}
