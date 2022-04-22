//
//  TasksTableViewCell.swift
//  mySheduleDz
//
//  Created by Valeriy Trusov on 28.02.2022.
//

import Foundation
import UIKit


class TasksTableViewCell: UITableViewCell {
    
    let taskName = UILabel(text: "Программирование", font: .avenirNextDemiBold18())
    let taskDescriptions = UILabel(text: "Научиться писать extensions", font: .avenirNext14())
    
    let readyButton : UIButton = {
        
        let button = UIButton()
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    weak var cellTaskDelegate : PressReadyTaskButtonProtocol?
    var index: IndexPath?

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        taskDescriptions.numberOfLines = 2

        setConstrains()
        
        readyButton.addTarget(self, action: #selector(readyButtonTapped), for: .touchUpInside)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func readyButtonTapped() {
        
        guard let index = index else { return }

        cellTaskDelegate?.readyButtonTapped(indexPath: index)
    }
    
    func setConstrains() {
        
        self.contentView.addSubview(readyButton)
        NSLayoutConstraint.activate([
            readyButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            readyButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            readyButton.heightAnchor.constraint(equalToConstant: 40),
            readyButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        self.addSubview(taskName)
        NSLayoutConstraint.activate([
            taskName.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            taskName.trailingAnchor.constraint(equalTo: readyButton.leadingAnchor, constant: -5),
            taskName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            taskName.heightAnchor.constraint(equalToConstant: 25),
        ])
        
        self.addSubview(taskDescriptions)
        NSLayoutConstraint.activate([
            taskDescriptions.topAnchor.constraint(equalTo: taskName.bottomAnchor, constant: 5),
            taskDescriptions.trailingAnchor.constraint(equalTo: readyButton.leadingAnchor, constant: -5),
            taskDescriptions.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            taskDescriptions.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
    
    func configure(model: TaskModel) {
        
        let textColor = UIColor().colorForCellText(color: model.taskColor)
        

        taskName.text = model.taskLessonName
        taskName.textColor = textColor
        taskDescriptions.text = model.taskDescription
        taskDescriptions.textColor = textColor
        backgroundColor = UIColor().colorFromHex(model.taskColor)
        taskDescriptions.adjustsFontSizeToFitWidth = false

        if model.taskReady {
            
            readyButton.setBackgroundImage(UIImage(systemName: "chevron.down.circle.fill"), for: .normal)
        }else {
            
            readyButton.setBackgroundImage(UIImage(systemName: "chevron.down.circle"), for: .normal)
        }
    }
}

