//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/12/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import Foundation

/// A singleton that manages network requests
class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    
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
}
