//
//  OptionsScheduleViewController.swift
//  mySheduleDz
//
//  Created by Valeriy Trusov on 02.03.2022.
//

import Foundation
import UIKit

class ScheduleOptionsTableViewController: UITableViewController {
    
    
    private let idOptionsCell = "idOptionsScheduleCell"
    private let idOptionsHeader = "idOptionsScheduleHeader"
    
    private let headerNameArray = ["Date and Time","Lesson","Teacher","Color","Period"]
    
     var cellNameArray = [["Date","Time"],
                         ["Name", "Type", "Building", "Audience"],
                         ["Teacher name"],
                         [""],
                         ["Repeat every 7 days"]]
    var dateArray : [Date] = []
    
    var scheduleModel = ScheduleModel()
    var editingModel : ScheduleModel?
    
    var hexColorCell = "1A4766"
    var isEdit  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Options schedule"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        
        
        tableView.register(OptionsTableViewCell.self, forCellReuseIdentifier: idOptionsCell)
        tableView.register(HeaderOptionTableViewCell.self, forHeaderFooterViewReuseIdentifier: idOptionsHeader)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        
        if isEdit {
            setModelValue()
        }

    }
    
        
    @objc private func saveButtonTapped() {
        
        if scheduleModel.scheduleDate == nil || scheduleModel.scheduleTime == nil || scheduleModel.scheduleName == "Unknown" {
            
            alertOK(title: "Error", message: "Requered fields: Date, Time, Name")
            
        }else if isEdit == false {
            scheduleModel.scheduleColor = hexColorCell
            RealmManager.shared.saveScheduleModel(model: scheduleModel)
            scheduleModel = ScheduleModel()
            alertOK(title: "Success", message: nil)
            hexColorCell = "1A4766"
            cellNameArray[2][0] = "Teacher name"
            tableView.reloadData()
        }else {
            
            scheduleModel.scheduleColor = hexColorCell
            RealmManager.shared.updateScheduleModel(oldModel: editingModel!, newModel: scheduleModel)
            scheduleModel = ScheduleModel()
            hexColorCell = "1A4766"
            cellNameArray = [["Date","Time"],
                                ["Name", "Type", "Building", "Audience"],
                                ["Teacher name"],
                                [""],
                                ["Repeat every 7 days"]]
            
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    private func setModelValue() {
        
        scheduleModel.scheduleDate = editingModel!.scheduleDate
        scheduleModel.scheduleTime = editingModel!.scheduleTime
        scheduleModel.scheduleName = editingModel!.scheduleName
        scheduleModel.scheduleRepeat = editingModel!.scheduleRepeat
        scheduleModel.scheduleType = editingModel!.scheduleType
        scheduleModel.scheduleColor = editingModel!.scheduleColor
        scheduleModel.scheduleAudience = editingModel!.scheduleAudience
        scheduleModel.scheduleWeekDay = editingModel!.scheduleWeekDay
        scheduleModel.scheduleTeacher = editingModel!.scheduleTeacher
        scheduleModel.scheduleBuilding = editingModel!.scheduleBuilding
    }
    
    //MARK: UITableViewDelegate, UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:  return 2
        case 1:  return 4
        case 2:  return 1
        case 3:  return 1
        default: return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idOptionsCell, for: indexPath) as! OptionsTableViewCell
        
        cell.switchRepeatDelegate = self

        if isEdit {
            
            cell.cellScheduleConfigure(nameArray: cellNameArray, indexPath: indexPath, hexColor: hexColorCell, switchIsActive: scheduleModel.scheduleRepeat)
        }else {
            cell.cellScheduleConfigure(nameArray: cellNameArray, indexPath: indexPath, hexColor: hexColorCell, switchIsActive: nil)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: idOptionsHeader) as! HeaderOptionTableViewCell
        header.headerConfigure(nameArray: headerNameArray, section: section)
        
        return header
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! OptionsTableViewCell
        
        switch indexPath {
        case [0,0]:
            alertDate(label: cell.nameCelllabel) { [self] (numberWeekDay, date) in
                scheduleModel.scheduleDate = date
                scheduleModel.scheduleWeekDay = numberWeekDay
                
        }
        case [0,1]:
            alertTime(label: cell.nameCelllabel) { [unowned self](time) in
                scheduleModel.scheduleTime = time
        }
        case [1,0]:
            alertForCellName(label: cell.nameCelllabel, name: "Name lesson", placeholder: "Enter name lesson") { [unowned self] text in
                scheduleModel.scheduleName = text
        }
        case [1,1]:
            alertForCellName(label: cell.nameCelllabel, name: "Type lesson", placeholder: "Enter type lesson") { [unowned self] text in
                scheduleModel.scheduleType = text
        }
        case [1,2]:
            alertForCellName(label: cell.nameCelllabel, name: "Building number", placeholder: "Enter number of building"){ [unowned self] text in
                scheduleModel.scheduleBuilding = text
        }
        case [1,3]:
            alertForCellName(label: cell.nameCelllabel, name: "Audience", placeholder: "Enter number of audience"){ [unowned self] text in
                scheduleModel.scheduleAudience = text
        }
        case [2,0]:pushControllers(vc: TeachersTableViewController())
        case [3,0]:pushControllers(vc: ScheduleColorsViewController())
        default: break
        }
    }
    
    func pushControllers(vc: UIViewController) {
        
        let viewController = vc
        navigationController?.navigationBar.topItem?.title = "Options"
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ScheduleOptionsTableViewController : SwitchRepeatProtocol {
    func switchRepeat(value: Bool) {
       
        scheduleModel.scheduleRepeat = value
    }
}
