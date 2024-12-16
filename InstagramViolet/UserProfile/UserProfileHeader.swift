//
//  UserProfileHeader.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 01.12.2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserProfileHeader: UICollectionViewCell {
    
    static let cellId = "UserProfileHeader"
    
    var user: User? {
        didSet {
            guard let userProfileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: userProfileImageUrl)
            usernameLabel.text = user?.username
        }
    }
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.grid, for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.list, for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.ribbon, for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        let postsText = NSMutableAttributedString(string: "\nposts", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedText.append(postsText)
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        let postsText = NSMutableAttributedString(string: "followers", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedText.append(postsText)
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        let postsText = NSMutableAttributedString(string: "following", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedText.append(postsText)
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews(profileImageView, usernameLabel, editProfileButton)
        
        setupBottomToolbar()
        setupUserStatsView()
        
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, paddingTop: 12, paddingLeading: 12, paddingTrailing: 0, paddingBottom: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        usernameLabel.anchor(top: profileImageView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: gridButton.topAnchor, paddingTop: 4, paddingLeading: 12, paddingTrailing: 12, paddingBottom: 4, width: 0, height: 0)
        
        editProfileButton.anchor(top: followersLabel.bottomAnchor, leading: postsLabel.leadingAnchor, trailing: followingLabel.trailingAnchor, bottom: nil, paddingTop: 12, paddingLeading: 0, paddingTrailing: 0, paddingBottom: 0, width: 0, height: 34)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(countPosts: Int) {
        let attributedText = NSMutableAttributedString(string: String(countPosts), attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        let postsText = NSMutableAttributedString(string: "\nposts", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedText.append(postsText)
        postsLabel.attributedText = attributedText
    }
    
    private func setupBottomToolbar() {
        let topDividerView = UIView()
        topDividerView.backgroundColor = .lightGray
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = .lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubviews(stackView, topDividerView, bottomDividerView)
        stackView.anchor(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: self.bottomAnchor, paddingTop: 0, paddingLeading: 0, paddingTrailing: 0, paddingBottom: 0, width: 0, height: 50)
        topDividerView.anchor(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: stackView.topAnchor, paddingTop: 0, paddingLeading: 0, paddingTrailing: 0, paddingBottom: 0, width: 0, height: 0.5)
        bottomDividerView.anchor(top: stackView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, paddingTop: 0, paddingLeading: 0, paddingTrailing: 0, paddingBottom: 0, width: 0, height: 0.5)
    }
    
    private func setupUserStatsView() {
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, trailing: self.trailingAnchor, bottom: nil, paddingTop: 12, paddingLeading: 12, paddingTrailing: -12, paddingBottom: 0, width: 0, height: 50)
        
    }
}
