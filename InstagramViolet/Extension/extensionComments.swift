//
//  extensionComments.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 24.12.2024.
//
import UIKit

extension CommentsController {
    func setupInitialStateNotificationCenter() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillShow),
                         name: UIResponder.keyboardWillShowNotification,
                         object: nil)
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillHide),
                         name: UIResponder.keyboardWillHideNotification,
                         object: nil)
    }

    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            textField.frame = CGRect(x: 0, y: view.frame.height - keyboardSize.height - 100 , width: view.frame.width, height: 100)
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        textField.frame = CGRect(x: 0, y: view.frame.height - 100, width: view.frame.width, height: 100)
    }
}
