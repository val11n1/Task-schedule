//
//  ContactsTableViewCell.swift
//  mySheduleDz
//
//  Created by Valeriy Trusov on 04.03.2022.
//
import Foundation
import UIKit


class ContactsTableViewCell: UITableViewCell {
    
    
    let contactImageView : UIImageView = {
        
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.fill") //UIImage.init(named: "morfContact1")
        iv.image?.withTintColor(.blue)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false

        return iv
    }()
    
    let phoneImageView : UIImageView = {
        
        let iv = UIImageView()
        iv.image = UIImage.init(systemName: "phone.fill")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let mailImageView : UIImageView = {
        
        let iv = UIImageView()
        iv.image = UIImage.init(systemName: "envelope.fill")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let nameLabel = UILabel(text: "Morf", font: UIFont.avenirNext18())
    let phoneLabel = UILabel(text: "+9 999 99 99 99", font: UIFont.avenirNext14())
    let mailLabel = UILabel(text: "Morfya@ti@mail.ru", font: UIFont.avenirNext14())

    
    override func layoutIfNeeded() {
        super.layoutSubviews()
        
        
        contactImageView.layer.cornerRadius = contactImageView.frame.height / 2
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setConstrains() {
        
        self.addSubview(contactImageView)
        NSLayoutConstraint.activate([
            contactImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            contactImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            contactImageView.widthAnchor.constraint(equalToConstant: 70),
            contactImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        self.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: contactImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 21)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [phoneImageView, phoneLabel, mailImageView, mailLabel], axis: .horizontal, spacing: 3, distribution: .equalCentering)
        
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contactImageView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 21)
        ])
    }
    
    func configure(model: ContactModel) {
        
        nameLabel.text  = model.contactName
        phoneLabel.text = model.contactPhone
        mailLabel.text  = model.contactMail
        
        if let image = model.contactImage {
            
            contactImageView.image = UIImage(data: image)
            
        }else {
           
            contactImageView.image = UIImage(systemName: "person.fill") //UIImage.init(named: "morfContact1")
        }
    }
    
}

