//
//  HomePostCell.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 16.12.2024.
//

import UIKit

final class HomePostCell: UICollectionViewCell {
    
    static let cellId = "HomePostCell"

    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    let photoImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .themeTextDark
        return label
    }()
    
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("···", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.likeUnselected.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.comment.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.send2.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.ribbon.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .themeTextDark
        return label
    }()
    
    func configure(post: Post) {
        photoImageView.loadImage(urlString: post.imageUrl)
        usernameLabel.text = post.user.username
        userProfileImageView.loadImage(urlString: post.user.profileImageUrl)
        
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        let attributedText = NSMutableAttributedString(string: post.user.username + " ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        let postsText = NSMutableAttributedString(string: post.caption, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.themeTextDark])
        let spaceText = NSMutableAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4)])
        let dataText = NSMutableAttributedString(string: timeAgoDisplay, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedText.append(postsText)
        attributedText.append(spaceText)
        attributedText.append(dataText)
        captionLabel.attributedText = attributedText
    }
    
    private func setupActionsButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        addSubviews(stackView, bookmarkButton)
        stackView.anchor(top: photoImageView.bottomAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, paddingTop: 0, paddingLeading: 12, paddingTrailing: 0, paddingBottom: 0, width: 120, height: 50)
        bookmarkButton.anchor(top: photoImageView.bottomAnchor, leading: nil, trailing: trailingAnchor, bottom: nil, paddingTop: 0, paddingLeading: 0, paddingTrailing: -16, paddingBottom: 0, width: 0, height: 50)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(userProfileImageView,
                    usernameLabel,
                    optionsButton,
                    photoImageView,
                    captionLabel)
        
        optionsButton.anchor(top: topAnchor, leading: usernameLabel.trailingAnchor, trailing: trailingAnchor, bottom: nil, paddingTop: 8, paddingLeading: 0, paddingTrailing: -8, paddingBottom: 0, width: 44, height: 40)
        usernameLabel.anchor(top: topAnchor, leading: userProfileImageView.trailingAnchor, trailing: optionsButton.leadingAnchor, bottom: nil, paddingTop: 8, paddingLeading: 8, paddingTrailing: 0, paddingBottom: 0, width: 0, height: 40)
        userProfileImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil , paddingTop: 8, paddingLeading: 8, paddingTrailing: 0, paddingBottom: 0, width: 40, height: 40)
        photoImageView.anchor(top: userProfileImageView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, paddingTop: 8, paddingLeading: 0, paddingTrailing: 0, paddingBottom: 0, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        setupActionsButtons()
        captionLabel.anchor(top: bookmarkButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeading: 8, paddingTrailing: -8, paddingBottom: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
