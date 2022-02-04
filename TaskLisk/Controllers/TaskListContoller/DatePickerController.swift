//
//  DatePicker.swift
//  TaskLisk
//
//  Created by Davit on 02.02.22.
//

import UIKit

class DatePickerController: UIViewController {
    let datePicker = UIDatePicker()
    var date: Date?
    
    var completion: ((Date?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .inline
        
        
        title = "Pick a date"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        view.addSubview(datePicker)
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    @objc func doneButtonTapped() {
        completion?(datePicker.date)
        dismiss(animated: true, completion: nil)
    }
}
