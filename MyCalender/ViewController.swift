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
    
    /// 日付のみを取り出す関数
    func dateFormat(date: Date) -> String {
         let formatter = DateFormatter()
         formatter.dateStyle = .long
         formatter.timeStyle = .none
         return formatter.string(from: date)
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
        scheduleList.removeAll()
        var schedulesPurposeList: [Schedule] = []
        let schedules = Utils.shared.load() ?? []
        for schedule in schedules {
            if dateFormat(date: schedule.date) == dateFormat(date: date) {
                schedulesPurposeList.append(schedule)
                scheduleList = schedulesPurposeList
            }
        }
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
}

extension ViewController: AddTaskViewControllerOutput {
    func notifyClose() {
        dismiss(animated: false, completion: .none)
        var schedulesPurposeList: [Schedule] = []
        let schedules = Utils.shared.load() ?? []
        for schedule in schedules {
            if dateFormat(date: schedule.date) == dateFormat(date: selectedDate) {
                schedulesPurposeList.append(schedule)
                scheduleList = schedulesPurposeList
            }
        }
        tableview.reloadData()
    }
    
}
