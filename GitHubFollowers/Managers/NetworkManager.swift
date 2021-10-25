//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/12/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import UIKit
import os.log

/// A singleton that manages network requests
class NetworkManager {

    // MARK: - Properties

    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>() // in singleton to create an appwide cache
    let decoder = JSONDecoder()

    // MARK: - Initializers

    private init() { // initialize Singleton
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }

    // MARK: - Public Methods

    /// Returns an array of Follower or an error
    /// - Parameters:
    ///   - username: A valid GitHub username string
    ///   - page: a integer for the page number
    ///   - completed: a closure for the network request and result handler
    func getFollowers(for username: String, page: Int) async throws -> [Follower] {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"

        guard let url = URL(string: endpoint) else {
            os_log("invalid URL for username", log: Log.network)
            throw GFError.invalidUsername
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        // handle the response. Check for success status code
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            os_log("invalid HTTP response", log: Log.network, type: .error)
            throw GFError.invalidResponse
        }

        do {
            os_log("JSON data decode SUCCESS", log: Log.network) // this line is in the wrong place
            return try decoder.decode([Follower].self, from: data)

        } catch {
            os_log("JSON parser failed", log: Log.network)
            throw GFError.invalidData
        }
    }

    /// Fetch information for user from network
    /// - Parameters:
    ///   - username: A valid GitHub username string
    ///   - completed: a closure for the network request and result handler
    func getUserInfo(for username: String) async throws -> User {
        let endpoint = baseURL + "\(username)"

        guard let url = URL(string: endpoint) else {
            throw GFError.invalidUsername
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        // handle the response. Check for success status code
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            os_log("invalid HTTP response", log: Log.network, type: .error)
            throw GFError.invalidResponse
        }

        do {
            return try decoder.decode(User.self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }

    /// Download Avatar Image
    /// - Parameters:
    ///   - urlString: The URL on the network to retrieve string
    ///   - completed: update UI
    func downloadImage(from urlString: String) async -> UIImage? {

        // return image if found in cache
        let cacheKey = NSString(string: urlString) // cache uses URL as key
        if let image = cache.object(forKey: cacheKey) { return image }

        // make a network request for the image
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}
