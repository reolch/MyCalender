//
//  Utils.swift
//  MyCalender
//
//  Created by Reolch on 2022/08/14.
//

import Foundation

class Utils: NSObject {
    static let shared = Utils()
    
    func save(Schedules: [Schedule]) {
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(Schedules) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "Schedules")
    }

    func load() -> [Schedule]? {
        let jsonDecoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: "Schedules"),
              let Schedules = try? jsonDecoder.decode([Schedule].self, from: data) else {
            return nil
        }
        return Schedules
    }
}


