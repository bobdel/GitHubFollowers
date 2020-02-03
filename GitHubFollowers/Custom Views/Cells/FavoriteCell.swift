//
//  FavoriteCell.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/25/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

    // MARK: - Properties

    static let reuseID = "FavoriteCell"

    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 26)

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    /// init required by the API to support storyboards
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout Methods

    /// call from cellForRowAtIndexPath to set this cell's properties
    func set(favorite: Follower) {
        avatarImageView.downloadImage(fromURL: favorite.avatarUrl)
        usernameLabel.text = favorite.login
    }

    private func configure() {
        addSubviews(avatarImageView, usernameLabel)

        accessoryType = .disclosureIndicator
        let padding: CGFloat = 12

        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),

            usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40)

        ])
    }
}
