//
//  UIView+Ext.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 2/2/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

extension UIView {

    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
