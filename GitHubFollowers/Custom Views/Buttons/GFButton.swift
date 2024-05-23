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
    convenience init(color: UIColor, title: String, systemImageName: String) {
        self.init(frame: .zero) // size created by autolayout
        set(color: color, title: title, systemImageName: systemImageName)
    }

    // MARK: - Layout Methods

    /// Configure common visual properties of button for iOS 15 button
    private func configure() {
        configuration = .tinted()
        configuration?.cornerStyle = .medium
        translatesAutoresizingMaskIntoConstraints = false
    }

    /// Configure button properties from a different class
    func set(color: UIColor, title: String, systemImageName: String) {

        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
        configuration?.title = title

        configuration?.image = UIImage(systemName: systemImageName)
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    GFButton(color: .blue, title: "Click Me", systemImageName: "Pencil")
}
