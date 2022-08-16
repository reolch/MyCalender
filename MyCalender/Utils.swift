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

    func load() -> [Schedule] {
        let jsonDecoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: "Schedules"),
              let Schedules = try? jsonDecoder.decode([Schedule].self, from: data) else {
            return []
        }
        return Schedules
    }
    
    func covertStringToDate(type: DateFormatType, date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale?
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.date(from: date)
    }
    
    func convertDateFormat(type: DateFormatType, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale?
        dateFormatter.dateFormat = type.rawValue
        if type == .Date {
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
        }
        if type == .DateWithoutTime {
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
        }
        return dateFormatter.string(from: date)
    }
    
    /// 一致するIDを持つ要素のIndexを返却する
    /// - Parameters:
    ///   - id: 見つけたい要素の識別子
    /// - Returns: 一致するIDを持つ要素のIndex
    func searchById(id: String) -> Int? {
        let schedules = load()
        for (index, schedule) in schedules.enumerated() {
            if schedule.id.uuidString == id {
                return index
            }
        }
        return nil
    }
    
    func searchByDate(date: Date) -> [Schedule] {
        var scheduleList: [Schedule] = []
        let schedules = load()
        for schedule in schedules {
            if convertDateFormat(type: .DateWithoutTime, date: schedule.date) == convertDateFormat(type: .DateWithoutTime ,date: date) {
                scheduleList.append(schedule)
            }
        }
        return scheduleList
    }
}
