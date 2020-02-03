//
//  UITableView+Ext.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 2/2/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

/// extension to remove excess lines on empty cells in UITableView
extension UITableView {

    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}

// not used in this app. Future reference.
extension UITableView {

    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
}
