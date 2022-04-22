//
//  UIcolor.swift
//  mySheduleDz
//
//  Created by Valeriy Trusov on 05.03.2022.
//

import UIKit

extension UIColor {
    
    func colorFromHex(_ hex: String) -> UIColor {
        
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            
            return UIColor.black
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        return UIColor(red:   CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                       blue:  CGFloat(rgb & 0x0000FF) / 255.0,
                       alpha: 1.0)
    }
    
    func colorForCellText(color: String) -> UIColor {

        var colorString = UIColor()

        switch color {
        case "BE2813": colorString = .cyan
        case "F07F5A": colorString = .black
        case "F3AF22": colorString = .black
        case "467C24": colorString = .black
        case "2D7FC1": colorString = .black
        case "1A4766": colorString = .systemCyan
        case "2D038F": colorString = .systemCyan
        default:break
        }

      return colorString
    }
}
