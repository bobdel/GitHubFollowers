//
//  UIHelper.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/13/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

/// a collection of utility functions needed to manage UI
enum UIHelper {

    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width // screen width
        let padding: CGFloat = 12 // UIEdgeInsets
        let minimumItemSpacing: CGFloat = 10 // column width
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2) // space available for cell content
        let itemWidth = availableWidth / 3 // column width

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)

        return flowLayout
    }

}
