//
//  UserSearchCell.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 16.12.2024.
//

import UIKit

final class UserSearchCell: UICollectionViewCell {
    
    static let cellId = "UserSearchCell"
    
    private let photoImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "Username"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = .lightGray
        addSubviews(photoImageView, usernameLabel, bottomDividerView)
        photoImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, paddingTop: 10, paddingLeading: 10, paddingTrailing: 0, paddingBottom: -10, width: 60, height: 60)
        usernameLabel.anchor(top: topAnchor, leading: photoImageView.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, paddingTop: 10, paddingLeading: 10, paddingTrailing: -10, paddingBottom: -10, width: 0, height: 0)
        bottomDividerView.anchor(top: nil, leading: photoImageView.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeading: 0, paddingTrailing: 0, paddingBottom: 0, width: 0, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(user: User) {
        photoImageView.loadImage(urlString: user.profileImageUrl)
        usernameLabel.text = user.username
    }
}
