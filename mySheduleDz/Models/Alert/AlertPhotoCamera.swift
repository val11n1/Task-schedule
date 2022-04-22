//
//  PhotoCameraAlert.swift
//  mySheduleDz
//
//  Created by Valeriy Trusov on 04.03.2022.
//
import UIKit

extension UIViewController {
    
    func alertPhotoOrCamera(completionHandler: @escaping (UIImagePickerController.SourceType)-> Void) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            
            let camera = UIImagePickerController.SourceType.camera
            completionHandler(camera)
        }
        
        let photoLibrary = UIAlertAction(title: "Photo library", style: .default) { _ in
            
            
            let photoLibrary = UIImagePickerController.SourceType.photoLibrary
            completionHandler(photoLibrary)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(camera)
        alert.addAction(photoLibrary)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }
}
