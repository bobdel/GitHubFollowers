//
//  ViewController+Ext.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/11/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {

    /// Creates and presents a custom alert on the main thread
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }

    /// Creates and presents an alert
    func presentDefaultError() {
            let alertVC = GFAlertViewController(
                title: "Something went wrong.",
                message: "We were unable to complete your task at this time. Please try again.",
                buttonTitle: "Ok"
            )
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
    }

    /// present SafariViewController
    func presentSafariViewController(with url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = .systemGreen
        present(safariViewController, animated: true)
    }

}
