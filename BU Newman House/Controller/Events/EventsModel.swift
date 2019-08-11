//
//  EventsModel.swift
//  BU Newman House
//
//  Created by Luke Redmore on 7/25/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import Foundation

struct EventsModel : Codable {
    let title : String
    let startTime : Date?
    let endTime : Date?
    let id : String
}
