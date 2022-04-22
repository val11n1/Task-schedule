//
//  ColorTaskViewController.swift
//  mySheduleDz
//
//  Created by Valeriy Trusov on 04.03.2022.
//

import Foundation
import UIKit

class TaskColorsViewController: UITableViewController {
    
    let idTasksColorCell = "idTasksColorCell"
    let idTaskssColorHeader = "idTaskssColorHeader"
    
    let headerNameArray = ["Red","Orange","Yellow","Green","Blue", "Deep blue", "Purple"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Color tasks"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        
        
        tableView.register(ColorsTableViewCell.self, forCellReuseIdentifier: idTasksColorCell)
        tableView.register(HeaderOptionTableViewCell.self, forHeaderFooterViewReuseIdentifier: idTaskssColorHeader)

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idTasksColorCell, for: indexPath) as! ColorsTableViewCell
        cell.cellConfigure(indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: idTaskssColorHeader) as! HeaderOptionTableViewCell
        header.headerConfigure(nameArray: headerNameArray, section: section)
        
        return header
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            switch indexPath.section {
            case 0: setColor(color: "BE2813")
            case 1: setColor(color: "F07F5A")
            case 2: setColor(color: "F3AF22")
            case 3: setColor(color: "467C24")
            case 4: setColor(color: "2D7FC1")
            case 5: setColor(color: "1A4766")
            case 6: setColor(color: "2D038F")
            default: setColor(color: "FFFFFF")
            }
    }
    
    private func setColor(color: String) {
        
        let vc = navigationController?.viewControllers[1] as? TaskOptionsTableView
        vc?.hexColorCell = color
        vc?.tableView.reloadRows(at: [[3,0]], with: .none)
        self.navigationController?.popViewController(animated: true)
    }
}
