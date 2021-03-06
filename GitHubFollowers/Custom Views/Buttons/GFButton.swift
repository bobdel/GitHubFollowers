//
//  GFButton.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/10/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

/// an app wide UIButton utility class
class GFButton: UIButton {

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    /// init required by the API to support storyboards
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Configure object specific visual properties of button
    convenience init(backgroundColor: UIColor, title: String) {
        self.init(frame: .zero) // size created by autolayout
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }

    // MARK: - Layout Methods

    /// Configure common visual properties of button
    private func configure() {
        layer.cornerRadius = 10
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        setTitleColor(.white, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }

    /// Configure button properties from a different class
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
}
