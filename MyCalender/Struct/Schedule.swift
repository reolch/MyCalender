//
//  Schedule.swift
//  MyCalender
//
//  Created by Reolch on 2022/08/16.
//

import Foundation

struct Schedule: Codable {
    var id = UUID()
    var title: String
    var date: Date
    
    init(title: String, date: Date) {
        self.title = title
        self.date = date
    }
}
