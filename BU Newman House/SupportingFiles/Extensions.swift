//
//  Extensions.swift
//  BU Newman House
//
//  Created by Luke Redmore on 7/26/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import Foundation

extension Date {
    
    func yearString() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy"
        return fmt.string(from: self)
    }
    func monthNumberString() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MM"
        return fmt.string(from: self)
    }
    func monthNameString() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MMMM"
        return fmt.string(from: self)
    }
    func monthAbbreviationString() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MMM"
        return fmt.string(from: self)
    }
    func monthYearString() -> String {
            let fmt = DateFormatter()
            fmt.dateFormat = "MMMM yyyy"
            return fmt.string(from: self)
        }
    func dayString() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "dd"
        return fmt.string(from: self)
    }
    func dateString() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MM/dd/yyyy"
        return fmt.string(from: self)
    }
    func timeString() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "hh:mm a"
        return fmt.string(from: self)
    }
    func dayOfWeekString() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "EEEE"
        return fmt.string(from: self)
    }
}
