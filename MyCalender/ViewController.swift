//
//  ViewController.swift
//  MyCalender
//
//  Created by Reolch on 2022/08/14.
//

import UIKit
import FSCalendar
import RealmSwift

class ViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet weak var calender: FSCalendar!
    @IBOutlet weak var tableview: UITableView!
    
    var scheduleList: [Schedule] = []
    var selectedDate: Date = Date()
    
    var itemList: Results<TodoModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        calender.delegate = self
        calender.dataSource = self
        
        let realm = try! Realm()
        let date = Utils.shared.convertDateFormat(type: .DateWithoutTime, date: selectedDate)
        itemList = realm.objects(TodoModel.self).filter("date == '\(date)'")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableview.reloadData()
    }
    
    @IBAction func didPushedAdd(_ sender: Any) {
        let nextView = storyboard?.instantiateViewController(identifier: "AddTaskViewController") as! AddTaskViewController
        nextView.delegate = self
        present(nextView, animated: true, completion: nil)
    }
}

extension ViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        let realm = try! Realm()
        let date = Utils.shared.convertDateFormat(type: .DateWithoutTime, date: selectedDate)
        itemList = realm.objects(TodoModel.self).filter("date == '\(date)'")
        tableview.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "normal")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = itemList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 列番号を渡す
        let nextView = storyboard?.instantiateViewController(identifier: "AddTaskViewController") as! AddTaskViewController
        nextView.delegate = self
        nextView.mode = .Edit
        nextView.id = itemList[indexPath.row].id
        present(nextView, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let realm = try! Realm()
        let deleteList = realm.objects(TodoModel.self).filter("id == '\(itemList[indexPath.row].id)'")
        
        try! realm.write {
            realm.delete(deleteList)
        }
        tableview.reloadData()
    }
}

extension ViewController: AddTaskViewControllerOutput {
    func notifyClose() {
        dismiss(animated: false, completion: .none)
        let realm = try! Realm()
        let date = Utils.shared.convertDateFormat(type: .DateWithoutTime, date: selectedDate)
        itemList = realm.objects(TodoModel.self).filter("date == '\(date)'")
        tableview.reloadData()
    }
}
