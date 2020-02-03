//
//  GFContainerView.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/12/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

/// An appwide UIView modal alert container
class GFAlertContainerView: UIView {

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    /// init required by the API to support storyboards
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout Methods

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.systemBackground

        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor

    }
}
