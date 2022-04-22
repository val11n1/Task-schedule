//
//  AlertFriendOrTeacher.swift
//  mySheduleDz
//
//  Created by Valeriy Trusov on 04.03.2022.
//

import UIKit

extension UIViewController {
    
    func alertFriendOrTeacher(label: UILabel, completionHandler: @escaping (String)-> Void) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let friends = UIAlertAction(title: "Friend", style: .default) { _ in
            
            label.text = "Friend"
            let typeContact = "Friend"
            completionHandler(typeContact)
        }
        
        let teacher = UIAlertAction(title: "Teacher", style: .default) { _ in
            
            label.text = "Teacher"
            let typeContact = "Teacher"
            completionHandler(typeContact)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(friends)
        alert.addAction(teacher)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }
}
