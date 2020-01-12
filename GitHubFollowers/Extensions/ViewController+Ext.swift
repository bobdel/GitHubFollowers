//
//  ViewController+Ext.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/11/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

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
    
    
    
}
