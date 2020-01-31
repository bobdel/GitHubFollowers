//
//  GFDataLoadingViewController.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/31/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

class GFDataLoadingViewController: UIViewController {
    
    var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /// overlay viewcontroller with an opaque layer to indicate loading state
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.20) { self.containerView.alpha = 0.8 }
        
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
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
    
    
    /// show loading state
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }

}
