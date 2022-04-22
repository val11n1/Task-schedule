//
//  TeachersViewController.swift
//  mySheduleDz
//
//  Created by Valeriy Trusov on 03.03.2022.
//

import UIKit
import RealmSwift

class TeachersTableViewController: UITableViewController {

    private let localRealm = try! Realm()
    private var contactsArray : Results<ContactModel>!
    private let teachedId = "teacherId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Teachers"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: teachedId)
        
        contactsArray = localRealm.objects(ContactModel.self).filter("contactType = 'Teacher'")
    }
    
    private func setTeacher(teacher: String) {
        
        let scheduleOption = self.navigationController?.viewControllers[1] as? ScheduleOptionsTableViewController
        scheduleOption?.scheduleModel.scheduleTeacher = teacher
        scheduleOption?.cellNameArray[2][0] = teacher
        scheduleOption?.tableView.reloadRows(at: [[2,0]], with: .none)
        self.navigationController?.popViewController(animated: true)
    }
   
    //MARK: UITableViewDelegate, UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return contactsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: teachedId, for: indexPath) as! ContactsTableViewCell
        let model = contactsArray[indexPath.row]
        cell.configure(model: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = contactsArray[indexPath.row]
        setTeacher(teacher: model.contactName)
    }
}
