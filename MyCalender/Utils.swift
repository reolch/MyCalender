//
//  Utils.swift
//  MyCalender
//
//  Created by Reolch on 2022/08/14.
//

import Foundation

class Utils: NSObject {
    static let shared = Utils()
    
    /// - FIXME 時間なしオプションが動作しない
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
}
