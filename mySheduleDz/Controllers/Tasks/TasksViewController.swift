//
//  TasksViewController.swift
//  mySheduleDz
//
//  Created by Valeriy Trusov on 27.02.2022.
//

import UIKit
import FSCalendar
import RealmSwift

class TasksViewController: UIViewController {

    
    var calendarHeightConstraint : NSLayoutConstraint!
    
    let localRealm = try! Realm()
    var taskArray : Results<TaskModel>!
    
    private var calendar: FSCalendar = {
        
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    let showHideButton : UIButton = {
        
        let button = UIButton()
        
        button.setTitle("Open calendar", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Demi Bold", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let tableView: UITableView = {
        
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let idTasksCell = "idTasksCell"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Tasks"
        calendar.delegate   = self
        calendar.dataSource = self
        calendar.scope = .week
        
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.bounces    = false
        
        tableView.register(TasksTableViewCell.self, forCellReuseIdentifier: idTasksCell)
        
        setConstrains()
        swipeAction()
        tasksOnDate(date: calendar.today!)
        showHideButton.addTarget(self, action: #selector(showHideButtonTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
        
    private func configureLabelText(cell: TasksTableViewCell) {
        
        
       if (cell.taskDescriptions.text?.count)! > 25 {
            
           let string = cell.taskDescriptions.text! as NSString
            cell.taskDescriptions.text = string.substring(to: 25) as String + "..."
        }
    }
    
    private func tasksOnDate(date: Date) {
        
        
//       let dateStart : Date = {
//
//           let components = DateComponents(hour: -3)
//            return Calendar.current.date(byAdding: components, to: date)!
//       }()
        
        let dateStart = date
        
        let dateEnd : Date = {
            
            let components = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: components, to: dateStart)!
        }()
        
        let predicate = NSPredicate(format: "taskDate BETWEEN %@", [dateStart, dateEnd])
        taskArray = localRealm.objects(TaskModel.self).filter(predicate).sorted(byKeyPath: "taskLessonName")
        tableView.reloadData()
    }
    
    @objc func addButtonTapped() {
       
        let TasksOption = TaskOptionsTableView()
        navigationController?.pushViewController(TasksOption, animated: true)
    }
   
    @objc func showHideButtonTapped() {
        
        if calendar.scope == .week {
            
            calendar.setScope(.month, animated: true)
            showHideButton.setTitle("Close calendar", for: .normal)
            
        }else {
            
            calendar.setScope(.week, animated: true)
            showHideButton.setTitle("Open calendar", for: .normal)
        }
    }
    
    
    
    //MARK: SwipeGestureRecognizer
    
    func swipeAction() {
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        calendar.addGestureRecognizer(swipeUp)
        
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        calendar.addGestureRecognizer(swipeDown)
    }
    
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        
        switch gesture.direction {
        case .up:
            showHideButtonTapped()
        case .down:
            showHideButtonTapped()
        default:break
        }
    }
    
    private func editModel(model: TaskModel) {
        
        let taskOptions = TaskOptionsTableView()
        taskOptions.isEdit = true
        taskOptions.editingModel = model
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: model.taskDate!)
        taskOptions.cellNameArray = [dateString, model.taskLessonName, model.taskDescription, ""]
        taskOptions.hexColorCell = model.taskColor
        navigationController?.pushViewController(taskOptions, animated: true)
    }
}

//MARK: UITAbleViewDelegate, UITAbleViewDataSource

extension TasksViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: idTasksCell, for: indexPath) as! TasksTableViewCell
        cell.cellTaskDelegate = self
        cell.configure(model: taskArray[indexPath.row])
        cell.index = indexPath
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editingRow = taskArray[indexPath.row]
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
                
                RealmManager.shared.deleteTaskModel(model: editingRow)
            tableView.reloadData()
            }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = taskArray[indexPath.row]
        editModel(model: model)
    }
}



//MARK: PressReadyTaskButtonProtocol


extension TasksViewController: PressReadyTaskButtonProtocol  {
    
    func readyButtonTapped(indexPath: IndexPath) {
        
        let task = taskArray[indexPath.row]
        RealmManager.shared.updateTaskModel(model: task, bool: !task.taskReady)
        tableView.reloadData()
    }
    
    
    
}

//MARK: FSCalendarDataSource, FSCalendarDelegate

extension TasksViewController : FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        tasksOnDate(date: date)
    }
}

//MARK: SetConstrains

extension TasksViewController {
    
    func setConstrains() {
        
        view.addSubview(calendar)
        
        calendarHeightConstraint = NSLayoutConstraint(item: calendar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        calendar.addConstraint(calendarHeightConstraint)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        
        view.addSubview(showHideButton)

        NSLayoutConstraint.activate([
            showHideButton.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 0),
            showHideButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            showHideButton.widthAnchor.constraint(equalToConstant: 100),
            showHideButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: showHideButton.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
   
}
