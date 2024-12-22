//
//  UIImage+ext.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 22.12.2024.
//
import UIKit

extension UIImage {
    func withAlpha(_ alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .copy, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
