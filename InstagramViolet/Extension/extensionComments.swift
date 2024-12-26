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

    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            containerView.frame = CGRect(x: 0, y: view.frame.height - keyboardSize.height - 50 , width: view.frame.width, height: 80)
            
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        containerView.frame = CGRect(x: 0, y: view.frame.height - 80, width: view.frame.width, height: 80)
    }
    
    @objc private func keyboardDidShow(notification: Notification) {
        if comments.count > 1 {
            let lastRowIndex = IndexPath(row: comments.count - 1, section: 0)
            let cellAttributes = collectionView.layoutAttributesForItem(at: lastRowIndex)
            if let cellFrame = cellAttributes?.frame {
                // Преобразуем координаты в координаты содержимого
                var visibleRect = collectionView.convert(cellFrame, from: collectionView)
                visibleRect.size.height += 60
                collectionView.scrollRectToVisible(visibleRect, animated: true)
            }
        }
    }
}
