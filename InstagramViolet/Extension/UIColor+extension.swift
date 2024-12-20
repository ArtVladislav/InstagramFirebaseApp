//
//  UIColor+extension.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 25.11.2024.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let darkTheme = UIColor(named: "ThemeDarkColor")
    static let darkTextTheme = UIColor(named: "ThemeTextDarkColor")
}

