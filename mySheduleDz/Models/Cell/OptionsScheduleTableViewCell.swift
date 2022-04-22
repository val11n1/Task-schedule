//
//  OptionsScheduleTableViewCell.swift
//  mySheduleDz
//
//  Created by Valeriy Trusov on 02.03.2022.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {
    
    
    let backgroundViewCell: UIImageView = {
        
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    var nameCelllabel : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = NSLineBreakMode.byCharWrapping
        label.numberOfLines = 3
        
        
        return label
    }()
    
    let repeatSwitch : UISwitch = {
        
        let repeatSwitch = UISwitch()
        repeatSwitch.isOn        = true
        repeatSwitch.isHidden    = true
        repeatSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        return repeatSwitch
    }()
    
    weak var switchRepeatDelegate : SwitchRepeatProtocol?

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstrains()
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        repeatSwitch.addTarget(self, action: #selector(switchChange), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellScheduleConfigure(nameArray: [[String]], indexPath: IndexPath, hexColor: String, switchIsActive: Bool?) {
        
        nameCelllabel.text = nameArray[indexPath.section][indexPath.row]
        repeatSwitch.isHidden = (indexPath.section == 4 ? false: true)
        let color = UIColor().colorFromHex(hexColor)
        backgroundViewCell.backgroundColor = (indexPath.section == 3 ? color: .white)
        repeatSwitch.onTintColor = color
        
        if switchIsActive != nil {
            
            repeatSwitch.isOn = switchIsActive!
        }
    }
    
    func cellTasksConfigure(nameArray: [String], indexPath: IndexPath, hexColor: String) {
        
        nameCelllabel.text = nameArray[indexPath.section]
        let color = UIColor().colorFromHex(hexColor)
        backgroundViewCell.backgroundColor = (indexPath.section == 3 ? color: .white)
    }
    
    
    func cellContactConfigure(nameArray: [String], indexPath: IndexPath, image: UIImage?) {
        self.backgroundViewCell.image = nil
        nameCelllabel.text = nameArray[indexPath.section]
        
        if image == nil {
            
            indexPath.section == 4 ? backgroundViewCell.image = UIImage(systemName: "person.fill.badge.plus") : nil
        }else {
            
            indexPath.section == 4 ? backgroundViewCell.image = image : nil
            backgroundViewCell.contentMode = .scaleAspectFill
            
        }
        
        }
    
    @objc func switchChange(paramTarget: UISwitch) {
        
        switchRepeatDelegate?.switchRepeat(value: paramTarget.isOn)
    }
    
    func setConstrains() {
       
        self.addSubview(backgroundViewCell)
        NSLayoutConstraint.activate([
            backgroundViewCell.topAnchor.constraint(equalTo:self.topAnchor),
            backgroundViewCell.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            backgroundViewCell.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            backgroundViewCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1)
            
        ])
        
        self.addSubview(nameCelllabel)
        NSLayoutConstraint.activate([
            nameCelllabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameCelllabel.leadingAnchor.constraint(equalTo: backgroundViewCell.leadingAnchor, constant: 15),
            nameCelllabel.widthAnchor.constraint(equalToConstant: 350)
        ])
        
        self.contentView.addSubview(repeatSwitch)
        NSLayoutConstraint.activate([
            repeatSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            repeatSwitch.trailingAnchor.constraint(equalTo: backgroundViewCell.trailingAnchor, constant: -20),
        ])
    }
}
