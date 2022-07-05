//
//  RRule+Extensions.swift
//  RRuleDemoApp
//
//  Created by Justin Honda on 7/3/22.
//

import Foundation

extension RRule.Frequency: Identifiable {
    public var id: Self { self }
}

extension RRule.Day: Identifiable {
    public var id: String {
        switch self {
            case .sunday:    return "Sunday"
            case .monday:    return "Monday"
            case .tuesday:   return "Tuesday"
            case .wednesday: return "Wednesday"
            case .thursday:  return "Thursday"
            case .friday:    return "Friday"
            case .saturday:  return "Saturday"
        }
    }
}
