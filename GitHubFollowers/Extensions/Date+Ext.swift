//
//  Date+Ext.swift
//  GitHubFollowers
//
//  Created by Robert DeLaurentis on 1/24/20.
//  Copyright © 2020 Robert DeLaurentis. All rights reserved.
//

import Foundation

extension Date {

    func convertToMonthYearFormat() -> String {
        return formatted(.dateTime.month().year())
    }
}
