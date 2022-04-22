//
//  TaskOptionTableView.swift
//  mySheduleDz
//
//  Created by Valeriy Trusov on 04.03.2022.
//


import Foundation
import UIKit
import RealmSwift

class TaskOptionsTableView: UITableViewController {
    
    let idOptionsTasksCell = "idOptionsTasksCell"
    let idOptionsTasksHeader = "idOptionsTasksHeader"
    
   private let headerNameArray = ["Date","Lesson","Task","Color"]
    
    var cellNameArray = ["Date", "Lesson", "Task",""]
    
    var taskModel = TaskModel()
    
    var hexColorCell = "1A4766"
    
    var isEdit = false
    var editingModel : TaskModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Option tasks"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        
        
        tableView.register(OptionsTableViewCell.self, forCellReuseIdentifier: idOptionsTasksCell)
        tableView.register(HeaderOptionTableViewCell.self, forHeaderFooterViewReuseIdentifier: idOptionsTasksHeader)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))

        if isEdit {
            
            setModelValue()
        }
    }
    
    
    @objc func saveButtonTapped() {
        
        
        if taskModel.taskDate == nil || taskModel.taskLessonName == "Unknown" || taskModel.taskDescription == "Unknown" {
            
            alertOK(title: "Error", message: "Requered fields: Date, Lesson, Task")
            
        }else if isEdit == false {
            
            taskModel.taskColor = hexColorCell
            RealmManager.shared.saveTaskModel(model: taskModel)
            taskModel = TaskModel()
            alertOK(title: "Success", message: nil)
            hexColorCell = "1A4766"
            tableView.reloadData()
        }else {
            
            taskModel.taskColor = hexColorCell
            RealmManager.shared.updateTaskModel(oldModel: editingModel!, newModel: taskModel)
            cellNameArray = ["Date", "Lesson", "Task",""]
            hexColorCell = "1A4766"
            navigationController?.popViewController(animated: true)
        }
    }
    
    func setModelValue() {
        
        taskModel.taskDate = editingModel!.taskDate
        taskModel.taskDescription = editingModel!.taskDescription
        taskModel.taskLessonName = editingModel!.taskLessonName
        taskModel.taskReady = editingModel!.taskReady

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idOptionsTasksCell, for: indexPath) as! OptionsTableViewCell
        cell.cellTasksConfigure(nameArray: cellNameArray, indexPath: indexPath, hexColor: hexColorCell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 2 ? 80: 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: idOptionsTasksHeader) as! HeaderOptionTableViewCell
        header.headerConfigure(nameArray: headerNameArray, section: section)
        
        return header
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! OptionsTableViewCell
        
        switch indexPath.section {
        case 0: alertDate(label: cell.nameCelllabel) { [unowned self]  _, date in
            
            self.taskModel.taskDate = date
        }
        case 1: alertForCellName(label: cell.nameCelllabel, name: "Name lesson", placeholder: "Enter name lesson"){ [unowned self] text in
            self.taskModel.taskLessonName = text
        }
        case 2: alertForCellName(label: cell.nameCelllabel, name: "Task description", placeholder: "Enter task description"){ [unowned self] text in
            self.taskModel.taskDescription = text
        }
        case 3: pushControllers(vc: TaskColorsViewController())
        default: break
        }
    }
    
    func pushControllers(vc: UIViewController) {
        
        let viewController = vc
        navigationController?.navigationBar.topItem?.title = "Options"
        navigationController?.pushViewController(viewController, animated: true)
    }
}
