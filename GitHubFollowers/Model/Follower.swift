//
//  Follower.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/12/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import Foundation

/// a single GitHub follower's information
struct Follower: Codable, Hashable {

    var login: String
    var avatarUrl: String

}
