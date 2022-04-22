//
//  ContactOptionTableViewController.swift
//  mySheduleDz
//
//  Created by Valeriy Trusov on 04.03.2022.
//

import Foundation
import UIKit
import CoreData

class ContactsOptionsTableViewController: UITableViewController {
    
    let idContactsOptionsCell = "idContactsOptionsCell"
    let idContactsOptionsHeader = "idContactsOptionsHeader"
    
    let headerNameArray = ["Name","Phone","Mail","Type", "Chose image"]
    
    var cellNameArray = ["Name","Phone","Mail","Type", ""]
    
    var isImageChange = false

    var contactModel = ContactModel()
    var editModel = false
    
    var dataImage : Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        title = "Option contact"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        
        
        tableView.register(OptionsTableViewCell.self, forCellReuseIdentifier: idContactsOptionsCell)
        tableView.register(HeaderOptionTableViewCell.self, forHeaderFooterViewReuseIdentifier: idContactsOptionsHeader)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        
    }
    
    
    
    @objc func saveButtonTapped() {
        
        if cellNameArray[0] == "Name" ||  cellNameArray[3] == "Type" {
            
            alertOK(title: "Error", message: "Requered fields:Name, Phone, Type")
        }else if editModel == false {
            
            setImageModel()
            setModel()
            
            RealmManager.shared.saveContactModel(model: contactModel)
            contactModel = ContactModel()
            
            cellNameArray = ["Name","Phone","Mail","Type", ""]
            alertOK(title: "Success", message: nil)
            tableView.reloadData()
        }else {
            setImageModel()
            RealmManager.shared.updateContactModel(model: contactModel, nameArray: cellNameArray, imageData: dataImage)
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setModel() {
        
        contactModel.contactName = cellNameArray[0]
        contactModel.contactPhone = cellNameArray[1]
        contactModel.contactMail = cellNameArray[2]
        contactModel.contactType = cellNameArray[3]
        contactModel.contactImage = dataImage
    }
    
    private func setImageModel() {
        
        if isImageChange {
            
            let cell = tableView.cellForRow(at: [4,0]) as! OptionsTableViewCell
            
            if cell.backgroundViewCell.image == UIImage(systemName: "person.fill.badge.plus") {
                
                dataImage = nil
                return
            }
            
            guard let imageData = cell.backgroundViewCell.image?.pngData() else { return }
            dataImage = imageData
            
            cell.backgroundViewCell.contentMode = .scaleAspectFit
            isImageChange = false
        }else {
            
            dataImage = nil
        }
    }
    
    
    //MARK: UITableViewDelegate, UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idContactsOptionsCell, for: indexPath) as! OptionsTableViewCell
        
        if editModel == false {
            
            cell.cellContactConfigure(nameArray: cellNameArray, indexPath: indexPath, image: nil)
            
        }else  if let data = contactModel.contactImage, let image = UIImage(data: data) {
            
            cell.cellContactConfigure(nameArray: cellNameArray, indexPath: indexPath, image: image)

        }else {
           
            cell.cellContactConfigure(nameArray: cellNameArray, indexPath: indexPath, image: nil)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 4 ?  200 : 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: idContactsOptionsHeader) as! HeaderOptionTableViewCell
        header.headerConfigure(nameArray: headerNameArray, section: section)
        
        return header
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! OptionsTableViewCell

        switch indexPath.section {
        case 0: alertForCellName(label: cell.nameCelllabel, name: "Name contact", placeholder: "Enter name contact"){ [unowned self] name in
            
            //self.contactModel.contactName = name
            cellNameArray[0] = name
        }
        case 1: alertForCellName(label: cell.nameCelllabel, name: "Phone contact", placeholder: "Enter phone contact"){ [unowned self] phone in
            
            //self.contactModel.contactPhone = phone
            cellNameArray[1] = phone
        }
        case 2: alertForCellName(label: cell.nameCelllabel, name: "Mail contact", placeholder: "Mail name contact"){ [unowned self] mail in
            
            //self.contactModel.contactMail = mail
            cellNameArray[2] = mail
        }
        case 3: alertFriendOrTeacher(label: cell.nameCelllabel) { [unowned self] type in
            //self.contactModel.contactType = type
            cellNameArray[3] = type
        }
        case 4: alertPhotoOrCamera { [unowned self] source in
            self.choseImagePicker(source: source)
        }
        default: print("print default contact options")
        }
    }
    
    func pushControllers(vc: UIViewController) {
        
        let viewController = vc
        navigationController?.navigationBar.topItem?.title = "Options"
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ContactsOptionsTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func choseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let cell = tableView.cellForRow(at: [4,0]) as! OptionsTableViewCell
        
        cell.backgroundViewCell.image = info[.editedImage] as? UIImage
        cell.backgroundViewCell.contentMode = .scaleAspectFill
        cell.backgroundViewCell.clipsToBounds = true
        //contactModel.contactImage = cell.backgroundViewCell.image?.pngData()
        isImageChange = true
        dismiss(animated: true, completion: nil)
    }
}
