//
//  Log.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 2/3/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import Foundation
import os.log

private let subsystem = "com.bobdel.ghfollowers"

struct Log {
    static let general = OSLog(subsystem: subsystem, category: "general")
    static let network = OSLog(subsystem: subsystem, category: "networking")
}
