//
//  CustomButton.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 25.11.2024.
//
import UIKit

final class CustomButton: UIButton {
    
//    var textFont: UIFont = UIFont.systemFont(ofSize: 20)
//    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.layer.cornerRadius = 5
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
