//
//  ScheduleTableViewCell.swift
//  mySheduleDz
//
//  Created by Valeriy Trusov on 28.02.2022.
//

import Foundation
import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    let lessonName     = UILabel(text: "",font: .avenirNextDemiBold18())
    let teacherName    = UILabel(text: "", font: .avenirNext18(), alignment: .right)
    let typeLabel      = UILabel(text: "Type", font: .avenirNext14(), alignment: .right)
    let lessonTime     = UILabel(text: "", font: .avenirNextDemiBold18())
    let lessonType     = UILabel(text: "", font: .avenirNextDemiBold14())
    let buildingLabel  = UILabel(text: "Building", font: .avenirNext14(), alignment: .right)
    let lessonBuilding = UILabel(text: "", font: .avenirNextDemiBold14())
    let audLabel       = UILabel(text: "Audience", font: .avenirNext14(), alignment: .right)
    let lessonAud      = UILabel(text: "", font: .avenirNextDemiBold14())
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstrains()
        
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstrains() {
        
        let topStackVIew = UIStackView(arrangedSubviews: [lessonName, teacherName], axis: .horizontal, spacing: 10, distribution: .fillEqually)

        self.addSubview(topStackVIew)
        NSLayoutConstraint.activate([
            topStackVIew.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            topStackVIew.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            topStackVIew.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            topStackVIew.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        self.addSubview(lessonTime)
        NSLayoutConstraint.activate([
            lessonTime.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            lessonTime.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            lessonTime.widthAnchor.constraint(equalToConstant: 100),
            topStackVIew.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        let bottomStackVIew = UIStackView(arrangedSubviews: [typeLabel, lessonType, buildingLabel, lessonBuilding, audLabel, lessonAud], axis: .horizontal, spacing: 5, distribution: .fillProportionally)

        self.addSubview(bottomStackVIew)
        NSLayoutConstraint.activate([
            bottomStackVIew.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            bottomStackVIew.leadingAnchor.constraint(equalTo: lessonTime.trailingAnchor, constant: 5),
            bottomStackVIew.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            bottomStackVIew.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func configure(model: ScheduleModel) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let textColor = UIColor().colorForCellText(color: model.scheduleColor)
        
        typeLabel.textColor = textColor
        buildingLabel.textColor = textColor
        audLabel.textColor = textColor
        
        lessonName.text = model.scheduleName
        lessonName.textColor = textColor
        teacherName.text = model.scheduleTeacher
        teacherName.textColor = textColor
        guard let time = model.scheduleTime else {return}
        lessonTime.text = dateFormatter.string(from: time)
        lessonTime.textColor = textColor
        lessonType.text = model.scheduleType
        lessonType.textColor = textColor
        lessonBuilding.text = model.scheduleBuilding
        lessonBuilding.textColor = textColor
        lessonAud.text = model.scheduleAudience
        lessonAud.textColor = textColor
        backgroundColor = UIColor().colorFromHex("\(model.scheduleColor)")
    }
}
