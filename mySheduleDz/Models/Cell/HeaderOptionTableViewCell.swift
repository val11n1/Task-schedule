//
//  HeaderOptionScheduleTableViewCell.swift
//  mySheduleDz
//
//  Created by Valeriy Trusov on 02.03.2022.
//

import UIKit
import SwiftUI

class HeaderOptionTableViewCell: UITableViewHeaderFooterView {
    
    let headerLabel = UILabel(text: "", font: .avenirNext14())
   
    override init(reuseIdentifier: String?) {
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        headerLabel.textColor = .darkGray
        self.contentView.backgroundColor = .systemGray6
        setConstrains()
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func headerConfigure(nameArray: [String], section: Int) {
        
        headerLabel.text = nameArray[section]
    }
    
    func setConstrains() {
       
        self.addSubview(headerLabel)
        NSLayoutConstraint.activate([
        
            headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
}
