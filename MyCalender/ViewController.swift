//
//  ViewController.swift
//  MyCalender
//
//  Created by Reolch on 2022/08/14.
//

import UIKit
import FSCalendar

class ViewController: UIViewController, UIAdaptivePresentationControllerDelegate {

    @IBOutlet weak var calender: FSCalendar!
    @IBOutlet weak var tableview: UITableView!
    
    var scheduleList: [Schedule] = []
    var selectedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        calender.delegate = self
        calender.dataSource = self
        // Do any additional setup after loading the view.
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
        scheduleList = Utils.shared.searchByDate(date: selectedDate)
        tableview.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "normal")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = scheduleList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 列番号を渡す
        let nextView = storyboard?.instantiateViewController(identifier: "AddTaskViewController") as! AddTaskViewController
        nextView.delegate = self
        nextView.mode = .Edit
        nextView.selectedSchedule = scheduleList[indexPath.row]
        present(nextView, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var schedules = Utils.shared.load()
        guard let foundIndex = Utils.shared.searchById(id: scheduleList[indexPath.row].id.uuidString) else { return }
        schedules.remove(at: foundIndex)
        Utils.shared.save(Schedules: schedules)
        scheduleList = Utils.shared.searchByDate(date: selectedDate)
        tableview.reloadData()
    }
}

extension ViewController: AddTaskViewControllerOutput {
    func notifyClose() {
        dismiss(animated: false, completion: .none)
        scheduleList = Utils.shared.searchByDate(date: selectedDate)
        tableview.reloadData()
    }
    
}
