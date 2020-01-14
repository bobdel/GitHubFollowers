//
//  GFAvatarImageView.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/12/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

class GFAvatarImageView: UIImageView {

    let cache = NetworkManager.shared.cache
    let placeholderImage = UIImage(named: "avatar-placeholder")!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    /// init required by the API to support storyboards
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false  
    }
    
    
     func downloadImage(from UrlString: String) {
        
        // return image if found in cache
        
        let cacheKey = NSString(string: UrlString) // cache uses URL as key
        
        if let image = cache.object(forKey: cacheKey) {
            self.image = image
            return
        }
        
        // if image not in cache, fetch from network
        // this code is here rather than in NetworkManager
        // because user never sees errors
        
        guard let url = URL(string: UrlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            
            // if we have an image execute the following lines:
            
            self.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async { self.image = image }
        }
        
        task.resume()
    }
}
