//
//  TodoModel.swift
//  MyCalender
//
//  Created by Yoshida Taishi on 2022/08/19.
//

import Foundation
import RealmSwift

class TodoModel: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var date: String = ""
}
