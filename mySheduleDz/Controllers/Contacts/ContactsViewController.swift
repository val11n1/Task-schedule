//
//  ContactsTableViewController.swift
//  mySheduleDz
//
//  Created by Valeriy Trusov on 04.03.2022.
//

import Foundation
import UIKit
import RealmSwift

class ContactsViewController: UIViewController {
   
    
    private let segmentedControl : UISegmentedControl = {
        
        let segmentedControl = UISegmentedControl(items: ["Friends", "Teachers"])
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }()
    
    private  let tableView : UITableView = {
        
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .singleLine

        return tableView
    }()
    
    let searchController = UISearchController()
    
    let idContactCell = "idContactCell"
    
    let localRealm = try! Realm()
    var contactsArray : Results<ContactModel>!
    var filtredArray : Results<ContactModel>!
    
    var searchBarisEmpty : Bool {
        
        guard let text = searchController.searchBar.text else { return true }
        return text.isEmpty
    }
    
    var isFiltering : Bool {
        
        return searchController.isActive && !searchBarisEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        searchController.searchBar.placeholder = "Search"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        navigationItem.searchController = searchController
        
        title = "Contacts"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .singleLine
        
        contactsArray = localRealm.objects(ContactModel.self).sorted(byKeyPath: "contactName").filter("contactType = 'Friend'")
        
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: idContactCell)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)

        setConstrains()
    }
    
    @objc private func segmentChanged() {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            contactsArray = localRealm.objects(ContactModel.self).sorted(byKeyPath: "contactName").filter("contactType = 'Friend'")
            tableView.reloadData()
        }else {
            
            contactsArray = localRealm.objects(ContactModel.self).sorted(byKeyPath: "contactName").filter("contactType = 'Teacher'")
            tableView.reloadData()
        }
    }
    
    @objc func addButtonTapped() {

        let optionVc = ContactsOptionsTableViewController()
        navigationController?.pushViewController(optionVc, animated: true)
    }
    
    @objc func editingModel(contactModel: ContactModel) {

        let optionVc = ContactsOptionsTableViewController()
        optionVc.contactModel = contactModel
        optionVc.editModel = true
        optionVc.cellNameArray = [contactModel.contactName,
                                 contactModel.contactPhone,
                                 contactModel.contactMail,
                                 contactModel.contactType,
                                 ""]
        optionVc.isImageChange = true
        navigationController?.pushViewController(optionVc, animated: true)
    }
}

extension ContactsViewController : UITableViewDelegate, UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return (isFiltering ? filtredArray.count: contactsArray.count)
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idContactCell, for: indexPath) as! ContactsTableViewCell
         let model = (isFiltering ? filtredArray[indexPath.row]: contactsArray[indexPath.row])
        cell.configure(model: model)
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let model = contactsArray[indexPath.row]
         editingModel(contactModel: model)
    }
    
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editingRow = contactsArray[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            
            RealmManager.shared.deleteContactModel(model: editingRow)
            tableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}


extension ContactsViewController {
    
    private func setConstrains() {
        
        let stackView = UIStackView(arrangedSubviews: [segmentedControl, tableView], axis: .vertical, spacing: 0, distribution: .equalSpacing)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ContactsViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(searchText: String) {
        
        filtredArray = contactsArray.filter("contactName CONTAINS[c] %@", searchText)
        tableView.reloadData()
    }
}
