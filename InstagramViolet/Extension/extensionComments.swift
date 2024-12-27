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
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardDidShow),
                         name: UIResponder.keyboardDidShowNotification,
                         object: nil)
    }
    
    func scrollToLastPost() {
        if comments.count > 0 {
            let lastRowIndex = IndexPath(row: comments.count - 1, section: 0)
            collectionView.scrollToItem(at: lastRowIndex, at: .bottom, animated: true)
        }
    }

    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            containerView.frame = CGRect(x: 0, y: view.frame.height - keyboardSize.height - 50 , width: view.frame.width, height: 80)
            collectionView.contentInset.bottom = keyboardSize.height + 30
            scrollToLastPost()
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        containerView.frame = CGRect(x: 0, y: view.frame.height - 80, width: view.frame.width, height: 80)
        collectionView.contentInset.bottom = 60
    }
    
    @objc private func keyboardDidShow(notification: Notification) {
        collectionView.contentInset.bottom = 65
    }
}
