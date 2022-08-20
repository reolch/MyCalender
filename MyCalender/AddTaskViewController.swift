//
//  AddTaskViewController.swift
//  MyCalender
//
//  Created by Reolch on 2022/08/14.
//

import UIKit
import RealmSwift


protocol AddTaskViewControllerOutput {
    func notifyClose()
}

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    var delegate: AddTaskViewControllerOutput?
    var mode: Mode = .Regist
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateTextField.delegate = self
        timeTextField.delegate = self
        initDatePicker()
        initTimePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if mode == .Edit {
            titleLabel.text = "タスクの編集"
            button.setTitle("編集", for: .normal)
            
            let realm = try! Realm()
            print(realm.objects(TodoModel.self))
            let filterId = id!
            let todoModels = realm.objects(TodoModel.self).filter("id == '\(filterId)'")
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale?
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            taskNameTextField.text = todoModels[0].title
            dateTextField.text = todoModels[0].date
            timeTextField.text = todoModels[0].time
        }
    }
    
    func initDatePicker(){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneForDate))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        datePicker.date = f.date(from: f.string(from: Date())) ?? Date()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
    }
    
    func initTimePicker() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneForTime))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        timePicker.datePickerMode = .time
        timePicker.timeZone = .current
        timePicker.locale = Locale.init(identifier: "Japanese")
        timePicker.preferredDatePickerStyle = .wheels
        timeTextField.inputView = timePicker
        timeTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneForDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale    = NSLocale(localeIdentifier: "ja_JP") as Locale?
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func doneForTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale    = Locale.init(identifier: "Japanese")
        timeTextField.text = dateFormatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    @IBAction func didPushedRegistButton(_ sender: Any) {
        var todoModel:TodoModel = TodoModel()
        let realm = try! Realm()
        if mode == .Regist {
            // テキストフィールドの名前を突っ込む
            todoModel.title = taskNameTextField.text ?? ""
            todoModel.date = dateTextField.text ?? ""
            todoModel.time = timeTextField.text ?? ""
            
            try! realm.write {
                realm.add(todoModel)
            }
        }
        
        if mode == .Edit {
            let filterId = id!
            let todoModels = realm.objects(TodoModel.self).filter("id == '\(filterId)'")
            // idなので一つの要素のみがヒットする
            todoModel = todoModels[0]
            
            try! realm.write {
                todoModel.title = taskNameTextField.text ?? ""
                todoModel.date = dateTextField.text ?? ""
                todoModel.time = timeTextField.text ?? ""
            }
        }
        delegate?.notifyClose()
    }
}

extension AddTaskViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        // キーボード入力や、カット/ペースによる変更を防ぐ
        return false
    }
}
