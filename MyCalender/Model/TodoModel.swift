//
//  TodoModel.swift
//  MyCalender
//
//  Created by Yoshida Taishi on 2022/08/19.
//

import Foundation
import RealmSwift

class TodoModel: Object {
    /// 検索用のID
    @objc dynamic var id: String = UUID().uuidString
    /// タイトル
    @objc dynamic var title: String = ""
    /// 日付
    @objc dynamic var date: String = ""
    /// 時刻
    @objc dynamic var time: String = ""
}
