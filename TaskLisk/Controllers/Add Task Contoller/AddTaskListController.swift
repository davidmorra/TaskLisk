//
//  AddTaskListController.swift
//  TaskLisk
//
//  Created by Davit on 28.01.22.
//

import UIKit

protocol AddTaskDelegate: AnyObject {
    func addTaskListController(_ controller: AddTaskListController, didFinishAdding task: TaskList)
    func addTaskListController(_ controller: AddTaskListController, didFinishEditing task: TaskList)
}

class AddTaskListController: UIViewController {
    weak var delegate: AddTaskDelegate?
    
    var taskToEdit: TaskList?
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    var taskCell = UITableViewCell()
    var taskTextField = UITextField()
    
    var remindCell = UITableViewCell()
    let remindToggle = UISwitch()
    
    let remindDateCell = UITableViewCell()
    let datePicker = UIDatePicker()
    
    var addTaskButton = UIBarButtonItem()
    
    override func loadView() {
        super.loadView()
        
        setupNavigation()
        
        setupTableView()
        layout()
        view.backgroundColor = .systemBackground
    
        createCells()
        setupDatePicker()
        
        addTaskButton.isEnabled = false
        taskTextField.delegate = self
        
        print(taskToEdit ?? "no task")
    }
    
    func createCells() {
        taskTextField = UITextField(frame: taskCell.contentView.bounds.insetBy(dx: 16, dy: 0))
        taskTextField.placeholder = "New task"
    
        taskTextField.text = taskToEdit?.title ?? ""
        
        taskTextField.becomeFirstResponder()
        taskTextField.returnKeyType = .done
        taskCell.addSubview(taskTextField)

        remindToggle.isOn = taskToEdit?.remind ?? false
        remindToggle.addTarget(self, action: #selector(remindToggleTapped), for: .valueChanged)
        
        remindCell.accessoryView = remindToggle
        var configuration = remindCell.defaultContentConfiguration()
        configuration.text = "Remind Me"
        remindCell.contentConfiguration = configuration
        
        remindDateCell.accessoryView = datePicker
        remindDateCell.isHidden = remindToggle.isOn ? false : true
        var dateConfigurate = remindDateCell.defaultContentConfiguration()
        dateConfigurate.text = "Due date"
        remindDateCell.contentConfiguration = dateConfigurate
        
    }
    
    func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = .current
        
        datePicker.date = taskToEdit?.dateToRemind ?? .now
    }
    
    func setupNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = false
        
        addTaskButton.isEnabled = false
        addTaskButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addNewTaskButtonTapped))
        navigationItem.rightBarButtonItem = addTaskButton
   }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc func addNewTaskButtonTapped() {
        
        if let taskToEdit = taskToEdit {
            taskToEdit.title = taskTextField.text!
            taskToEdit.remind = remindToggle.isOn
            taskToEdit.dateToRemind = datePicker.date
            
            
            delegate?.addTaskListController(self, didFinishEditing: taskToEdit)
        } else {
            let task = TaskList()
            task.title = taskTextField.text!
            task.remind = remindToggle.isOn
            task.dateToRemind = remindToggle.isOn ? datePicker.date : nil
            
            delegate?.addTaskListController(self, didFinishAdding: task)
        }
        
    }

    //MARK: - Remind toggle tapped
    @objc func remindToggleTapped() {
        remindDateCell.isHidden = remindToggle.isOn ? false : true
    }
}

//MARK: - Tableview methods
extension AddTaskListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0: return self.taskCell
        case 1: return self.remindCell
        case 2: return self.remindDateCell
        default: fatalError("Unknown row in section 0")
        }
    }

}

//MARK: - TextField methods
extension AddTaskListController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
            
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.count < 1 {
            addTaskButton.isEnabled = false
            addTaskButton.tintColor = .systemGray2
        } else {
            addTaskButton.isEnabled = true
            addTaskButton.tintColor = .systemBlue
        }
    }
}
