//
//  PressButtonProtocol.swift
//  mySheduleDz
//
//  Created by Valeriy Trusov on 28.02.2022.
//

import Foundation

protocol PressReadyTaskButtonProtocol: AnyObject {
    
    func readyButtonTapped(indexPath: IndexPath) 
}


protocol SwitchRepeatProtocol: AnyObject {
    
    func switchRepeat(value: Bool)
}
