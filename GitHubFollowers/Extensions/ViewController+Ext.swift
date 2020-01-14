//
//  ViewController+Ext.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/11/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

fileprivate var containerView: UIView!

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
    
    /// overlay viewcontroller with an opaque layer to indicate loading state
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.20) { containerView.alpha = 0.8 }
        
        let activityIndicatior = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicatior)
        
        activityIndicatior.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicatior.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatior.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicatior.startAnimating()
    }
    
    /// dismiss loading overlay
    func dismissLoadingView() {
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    
    /// show loading state
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}


