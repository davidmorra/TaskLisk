//
//  ViewController.swift
//  TaskLisk
//
//  Created by Davit on 23.01.22.
//

import UIKit

class TaskListViewController: UIViewController {

    let tableView = UITableView(frame: .zero, style: .plain)
    var taskList = [TaskList]()
    var addTaskButton = UIButton()
        
    let cellId = "taskCell"
    
    let emptyListView = EmptyListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let task = TaskList()
//        task.title = "Workout"
//
//        taskList.append(contentsOf: [task])
        setupNavigation()
        
        style()
        layout()
        
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emptyListView.isHidden = taskList.count == 0 ? false : true
    }
    
    //Sheet presentation
    func showMyViewControllerInACustomizedSheet(_ task: TaskList, for indexPath: IndexPath) {
        let datePickerController = DatePickerController()
        let navdatePickerController = UINavigationController(rootViewController: datePickerController)
        
        datePickerController.completion = { [unowned self] date in
            guard let date = date else {
                return
            }
            
            if task.remind == false || task.dateToRemind == nil {
                task.dateToRemind = date
                task.remind = true
            } else if task.remind == true {
                task.remind = false
            }
            
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        if let sheet = navdatePickerController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.preferredCornerRadius = 18
        }
        
        present(navdatePickerController, animated: true)
    }


    func setupNavigation() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = false
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.circle"), style: .plain, target: self, action: #selector(editTableViewTapped))
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TaskListCell.self, forCellReuseIdentifier: cellId)
        
        tableView.separatorInset = .zero
    }
    
    func style() {
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        
        var configuration = UIButton.Configuration.filled()
        let imageWeight = UIImage.SymbolConfiguration(weight: .bold)
        configuration.image = UIImage(systemName: "plus", withConfiguration: imageWeight)
        configuration.cornerStyle = .capsule
        configuration.buttonSize = .large
        
        addTaskButton.configuration = configuration
        addTaskButton.addTarget(self, action: #selector(newTaskButtonTapped), for: .primaryActionTriggered)
        
        
        emptyListView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout() {
        view.addSubview(tableView)
        view.addSubview(addTaskButton)
        view.addSubview(emptyListView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            emptyListView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyListView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyListView.widthAnchor.constraint(equalToConstant: 188),
            emptyListView.heightAnchor.constraint(equalToConstant: 188),
        ])
    }
    
    //MARK: - Add new task
    @objc func newTaskButtonTapped() {
        let addTaskContoller = AddTaskListController()
        addTaskContoller.delegate = self
        addTaskContoller.title = "New task"
        
        navigationController?.pushViewController(addTaskContoller, animated: true)
    }
    
    // MARK: - Edit cell function
    @objc func editTableViewTapped() {
        self.taskList = taskList.sorted { $0.title > $1.title }
        tableView.reloadData()
    }
}

//MARK: - Delegates
extension TaskListViewController: AddTaskDelegate {
    func addTaskListController(_ controller: AddTaskListController, didFinishAdding task: TaskList) {
        let index = taskList.count
        let indexPath = IndexPath(row: index, section: 0)
        
        taskList.append(task)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func addTaskListController(_ controller: AddTaskListController, didFinishEditing task: TaskList) {
        if let index = taskList.firstIndex(where: { $0.title == task.title }) {
            let indexPath = IndexPath(row: index, section: 0)
            
//            taskList[indexPath.row].title = task.title
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
}

extension TaskListViewController: UITextFieldDelegate {
    
}

//MARK: - TableView Data Source
extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? TaskListCell else {
            return UITableViewCell()
        }
                
        cell.tasks = taskList[indexPath.row]
        cell.accessoryType = .detailButton
                
        if taskList[indexPath.row].done {
            cell.taskLabel.makeStrikeThrough(cell.tasks?.title ?? "")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let addTaskListController = AddTaskListController()
        addTaskListController.delegate = self
        addTaskListController.title = "Edit task"
        
        let task = taskList[indexPath.row]
        addTaskListController.taskToEdit = task
        addTaskListController.taskTextField.text = task.title

        navigationController?.pushViewController(addTaskListController, animated: true)
    }
    
}

//MARK: - Tableview gestures
extension TaskListViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { [weak self] _ , _ , handler in
            
            self?.taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            handler(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")

        let remindAction = UIContextualAction(style: .normal, title: nil) { [unowned self] _ , _ , handler in
            
            //if reminder is On
            if self.taskList[indexPath.row].remind {
                self.taskList[indexPath.row].remind = false
                self.tableView.reloadRows(at: [indexPath], with: .automatic)

            } else {
                showMyViewControllerInACustomizedSheet(taskList[indexPath.row], for: indexPath)
            }

            handler(false)
        }
        
        remindAction.backgroundColor = .systemYellow
        remindAction.image = taskList[indexPath.row].remind ? UIImage(systemName: "bell.slash") : UIImage(systemName: "bell.fill")

        return UISwipeActionsConfiguration(actions: [deleteAction, remindAction])
    }
    
    // Leading Swipe
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let doneAction = UIContextualAction(style: .normal, title: nil) { [unowned self] _ , _ , handler in
            
            if self.taskList[indexPath.row].done == true {
                self.taskList[indexPath.row].done = false
            } else {
                self.taskList[indexPath.row].done = true
            }
            
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
            handler(true)
        }
        
        doneAction.backgroundColor = .systemBlue
        let imageConfig = UIImage.SymbolConfiguration(weight: .bold)

        if taskList[indexPath.row].done {
            doneAction.image = UIImage(systemName: "minus", withConfiguration: imageConfig)
        } else {
            doneAction.image = UIImage(systemName: "checkmark", withConfiguration: imageConfig)
        }
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [doneAction])
        
        return swipeConfig
    }
}
