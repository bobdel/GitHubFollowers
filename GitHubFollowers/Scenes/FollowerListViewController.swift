//
//  FollowerListViewController.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/10/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

class FollowerListViewController: GFDataLoadingViewController {

    // MARK: - Enumerations

    enum Section { // required by diffable data source
        case main
    }

    // MARK: properties

    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isLoadingMoreFollowers = false

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    // MARK: - Initializers

    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Viewcontroller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Layout Methods

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view)
                                          )

        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }

    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    private func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()

            switch result {
            case .success(let followers):
                self.updateUI(with: followers)

            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff", message: error.rawValue, buttonTitle: "Ok")
            }
        }
        self.isLoadingMoreFollowers = false
    }

    func updateUI(with followers: [Follower]) {
        if followers.count < 100 { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)

        if self.followers.isEmpty {
            let message = "This user does not have any followers. Go follow them. 😃"
            DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
            return
        }

        self.updateData(on: self.followers)
    }

    // MARK: - Diffable Datasource Methods

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FollowerCell.reuseID,
                // swiftlint:disable force_cast
                for: indexPath) as! FollowerCell
                // swiftlint:enable force_cast

                cell.set(follower: follower)

                return cell
        })
    }

    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }

    @objc func addButtonTapped() {
        showLoadingView()

        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()

            switch result {
            case .success(let user):
                self.addUserToFavorites(user: user)

            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong",
                                                message: error.rawValue,
                                                buttonTitle: "Ok") // network error
            }
        }
    }

        func addUserToFavorites(user: User) {
            let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)

            PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                guard let self = self else { return }

                guard let error = error else { // if the update error is nil, Success!
                    self.presentGFAlertOnMainThread(title: "Success",
                                                    message: "You have successfully favorited this user 🎉",
                                                    buttonTitle: "Hooray!")
                    return
                }
                self.presentGFAlertOnMainThread(title: "Something went wrong.",
                                                message: error.rawValue,
                                                buttonTitle: "Ok") // update error
        }
    }
}

// MARK: - Extensions (Delegation Conformance)

/// UICollectionViewDelegate Conformance
extension FollowerListViewController: UICollectionViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }

    // handle user tap on follower list
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]

        let destinationViewController = UserInfoViewController()
        destinationViewController.username = follower.login
        destinationViewController.delegate = self
        let navController = UINavigationController(rootViewController: destinationViewController)
        present(navController, animated: true)
    }
}

/// UISearchController Search Results
extension FollowerListViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }

        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)

    }
}

/// React to tap from UserInfoView
extension FollowerListViewController: UserInfoViewControllerDelegate {

    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        page = 1

        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)

        getFollowers(username: username, page: page)

    }

}
