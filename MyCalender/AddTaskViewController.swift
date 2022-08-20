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
    @IBOutlet weak var button: UIButton!
    
    let datePicker = UIDatePicker()
    
    var delegate: AddTaskViewControllerOutput?
    var mode: Mode = .Regist
    var selectedRow: Int?
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
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
        var todoModel:TodoModel = TodoModel()
        let realm = try! Realm()
        if mode == .Regist {
            // テキストフィールドの名前を突っ込む
            todoModel.title = taskNameTextField.text ?? ""
            guard let date = Utils.shared.covertStringToDate(type: .Date, date: dateTextField.text ?? "") else { return }
            todoModel.date = Utils.shared.convertDateFormat(type: .DateWithoutTime, date: date)
            
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
                guard let date = Utils.shared.covertStringToDate(type: .Date, date: dateTextField.text ?? "") else { return }
                todoModel.date = Utils.shared.convertDateFormat(type: .DateWithoutTime, date: date)
            }
        }
        delegate?.notifyClose()
    }
}
