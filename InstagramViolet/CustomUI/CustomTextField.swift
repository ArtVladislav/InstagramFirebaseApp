//
//  CustomTextField.swift
//  GuessTheNumber
//
//  Created by Владислав Артюхов on 23.11.2024.
//
import UIKit

final class CustomTextField: UITextField {
    
    // Определяем отступы
    var textPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(white: 0, alpha: 0.07)
        self.borderStyle = .roundedRect
        self.font = UIFont.systemFont(ofSize: 14)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        // Устанавливаем отступ для текста
        return bounds.inset(by: textPadding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        // Устанавливаем отступ для placeholder
        return bounds.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        // Устанавливаем отступ при редактировании (текстовое поле активно)
        return bounds.inset(by: textPadding)
    }
    
}
