//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/12/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit

/// A singleton that manages network requests
class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>() // in singleton to create an appwide cache
    
    // initialize Singleton
    private init() { }
    
    
    /// Returns an array of Follower or an error
    /// - Parameters:
    ///   - username: A valid GitHub username string
    ///   - page: a integer for the page number
    ///   - completed: a closure for the network request and result handler
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // handle the error. If error not nil call completion handler with error message
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            // handle the response. Check for success status code or call completion handler
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            // handle the data
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
        
    }
    
    
    /// Returns an array of Follower or an error
    /// - Parameters:
    ///   - username: A valid GitHub username string
    ///   - page: a integer for the page number
    ///   - completed: a closure for the network request and result handler
    func getUserInfo(for username: String, completed: @escaping (Result<User, GFError>) -> Void) {
        let endpoint = baseURL + "\(username)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // handle the error. If error not nil call completion handler with error message
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            // handle the response. Check for success status code or call completion handler
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            // handle the data
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let user = try decoder.decode(User.self, from: data)
                completed(.success(user))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        
        // return image if found in cache
        
        let cacheKey = NSString(string: urlString) // cache uses URL as key
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image) // send image to completion handler
            return
        }
        
        // if image not in cache, fetch from network
        // this code is terse because
        // user never sees errors
        
        guard let url = URL(string: urlString) else {
            completed(nil) // no image URL available
            return
        }
        
        // make a network request for the image
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil) // no image available
                    return
                }
                        
            // if we have an image
            
            self.cache.setObject(image, forKey: cacheKey)
            
            completed(image) // this is the image created on lne 143
        }
        
        task.resume()
        
    }
}
