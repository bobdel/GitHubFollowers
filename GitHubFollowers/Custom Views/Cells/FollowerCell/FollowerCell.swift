//
//  FollowerCell.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/12/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit
import SwiftUI

class FollowerCell: UICollectionViewCell {

    // MARK: - Properties

    static let reuseID = "FollowerCell"

    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    /// init required by the API to support storyboards
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// call from cell creation in vc to access FollowerCell properties
    func set(follower: Follower) {
        if #available(iOS 16.0, *) {
            contentConfiguration = UIHostingConfiguration { FollowerView(follower: follower) }
        } else {
            avatarImageView.downloadImage(fromURL: follower.avatarUrl)
            usernameLabel.text = follower.login
        }
    }

    // MARK: - Layout Methods

    private func configure() {
        addSubviews(avatarImageView, usernameLabel)

        let padding: CGFloat = 8

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

    }
}
