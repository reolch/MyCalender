//
//  AddTaskViewController.swift
//  MyCalender
//
//  Created by Reolch on 2022/08/14.
//

import UIKit



protocol AddTaskViewControllerOutput {
    func notifyClose()
}

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    let datePicker = UIDatePicker()
    
    var delegate: AddTaskViewControllerOutput?
    var mode: Mode = .Regist
    var selectedRow: Int?
    var selectedSchedule: Schedule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if selectedRow != nil {
            button.setTitle("編集", for: .normal)
        }
        if selectedSchedule != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale?
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            taskNameTextField.text = selectedSchedule?.title
            dateTextField.text = dateFormatter.string(from: selectedSchedule?.date ?? Date())
        }
    }
    
    func createDatePicker(){
        // DatePickerModeをDate(日付)に設定
        datePicker.datePickerMode = .date
        // DatePickerを日本語化
        datePicker.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        // textFieldのinputViewにdatepickerを設定
        dateTextField.inputView = datePicker
        // UIToolbarを設定
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        // Doneボタンを追加
        toolbar.setItems([doneButton], animated: true)
        // FieldにToolbarを追加
        dateTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneClicked(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.locale    = NSLocale(localeIdentifier: "ja_JP") as Locale?
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @IBAction func didPushedRegistButton(_ sender: Any) {
        guard let date = Utils.shared.covertStringToDate(type: .Date, date: dateTextField.text ?? "") else { return }
        var schedules = Utils.shared.load()
        
        if mode == .Edit && selectedRow != nil {
            var scheduleList: [Schedule] = []
            scheduleList = Utils.shared.searchByDate(date: date)
            let scheduleDate = Schedule.init(title: taskNameTextField.text ?? "", date: date)
            scheduleList[selectedRow!] = scheduleDate
        } else {
            let schedule = Schedule.init(title: taskNameTextField.text ?? "", date: date)
            schedules.append(schedule)
        }
        Utils.shared.save(Schedules: schedules)
        delegate?.notifyClose()
    }
}
