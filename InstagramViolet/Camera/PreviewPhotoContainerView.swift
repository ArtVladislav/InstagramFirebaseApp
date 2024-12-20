//
//  PreviewPhotoContainerView.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 19.12.2024.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.cancelShadow.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let saveImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.saveShadow.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(previewImageView, cancelButton, saveImageButton)
        previewImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeading: 0, paddingTrailing: 0, paddingBottom: 0, width: 0, height: 0)
        cancelButton.anchor(top: topAnchor, leading: nil, trailing: trailingAnchor, bottom: nil, paddingTop: 100, paddingLeading: 0, paddingTrailing: -16, paddingBottom: 0, width: 50, height: 50)
        saveImageButton.anchor(top: nil, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, paddingTop: 0, paddingLeading: 16, paddingTrailing: 0, paddingBottom: -100, width: 50, height: 50)
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        saveImageButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleCancel() {
        self.removeFromSuperview()
    }
    
    @objc func handleSave() {
        guard let previewImageView = previewImageView.image else { return }
        let library = PHPhotoLibrary.shared()
        library.performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: previewImageView)
        } completionHandler: { success, err in
            if let err = err {
                print("Failed to save image: \(err)")
                return
            }
            DispatchQueue.main.async {
                let savedLabel = UILabel()
                savedLabel.text = "Saved Successfully"
                savedLabel.textAlignment = .center
                savedLabel.textColor = .white
                savedLabel.numberOfLines = 0
                savedLabel.layer.cornerRadius = 30
                savedLabel.clipsToBounds = true
                savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
                savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                savedLabel.center = self.center
                self.addSubview(savedLabel)
                savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }) { completed in
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        savedLabel.alpha = 0
                    }) { completed in
                        savedLabel.removeFromSuperview()
                    }
                }
            }
            print("Successfully saved image")
        }
    }
}
