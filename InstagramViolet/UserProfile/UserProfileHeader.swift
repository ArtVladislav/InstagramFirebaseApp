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
    var user: User?
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.grid, for: .normal)
        button.tintColor = UIColor.gridList
        button.tintColor = UIColor.mainBlue()
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.list, for: .normal)
        button.tintColor = UIColor.gridList
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.ribbon, for: .normal)
        button.tintColor = UIColor.gridList
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let editProfileOrFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.customThemeDarkText, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.darkGray.cgColor
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .customThemeDark
        addSubviews(profileImageView, usernameLabel, editProfileOrFollowButton)
        
        setupBottomToolbar()
        setupUserStatsView()
        editProfileOrFollowButton.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, paddingTop: 12, paddingLeading: 12, paddingTrailing: 0, paddingBottom: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        usernameLabel.anchor(top: profileImageView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: gridButton.topAnchor, paddingTop: 4, paddingLeading: 12, paddingTrailing: 12, paddingBottom: 4, width: 0, height: 0)
        
        editProfileOrFollowButton.anchor(top: followersLabel.bottomAnchor, leading: postsLabel.leadingAnchor, trailing: followingLabel.trailingAnchor, bottom: nil, paddingTop: 12, paddingLeading: 0, paddingTrailing: 0, paddingBottom: 0, width: 0, height: 34)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(user: User, postsCount: Int, followersCount: Int, followingCount: Int) {
        self.user = user
        profileImageView.loadImage(urlString: user.profileImageUrl)
        usernameLabel.text = user.username
        setupEditProfileButton()
        
        let attributedPostCount = NSMutableAttributedString(string: String(postsCount), attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        let postText = NSMutableAttributedString(string: "\nposts", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedPostCount.append(postText)
        postsLabel.attributedText = attributedPostCount
        
        let attributedFollowersCount = NSMutableAttributedString(string: String(followersCount), attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        let followersText = NSMutableAttributedString(string: "\nfollowers", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedFollowersCount.append(followersText)
        followersLabel.attributedText = attributedFollowersCount
        
        let attributedFollowingCount = NSMutableAttributedString(string: String(followingCount), attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        let followingText = NSMutableAttributedString(string: "\nfollowing", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedFollowingCount.append(followingText)
        followingLabel.attributedText = attributedFollowingCount
    }
    
    private func setupEditProfileButton() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = self.user?.uid else { return }
        if currentUserId == userId {
            editProfileOrFollowButton.setTitle("Edit Profile", for: .normal)
        } else {
            Database.database().reference().child("following").child(currentUserId).child(userId).observeSingleEvent(of: .value) { snapshot in
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.setupTitleUnfollow()
                } else {
                    self.setupTitleFollow()
                }
            } withCancel: { err in
                print("Failed to observe following: \(err)")
            }
        }
    }
    
    private func setupBottomToolbar() {
        let topDividerView = UIView()
        topDividerView.backgroundColor = .lightGray
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = .lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        gridButton.addTarget(self, action: #selector(handleChangeToGrid), for: .touchUpInside)
        listButton.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        bookmarkButton.addTarget(self, action: #selector(handleChangeToBookmark), for: .touchUpInside)
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
    
    private func setupTitleFollow() {
        self.editProfileOrFollowButton.setTitle("Follow", for: .normal)
        self.editProfileOrFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        self.editProfileOrFollowButton.setTitleColor(.customThemeDarkText, for: .normal)
        self.editProfileOrFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    private func setupTitleUnfollow() {
        self.editProfileOrFollowButton.backgroundColor = .customThemeDark
        self.editProfileOrFollowButton.setTitle("Unfollow", for: .normal)
        self.editProfileOrFollowButton.setTitleColor(.customThemeDarkText, for: .normal)
        self.editProfileOrFollowButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @objc func handleChangeToGrid() {
        gridButton.tintColor = .mainBlue()
        listButton.tintColor = UIColor.gridList
        bookmarkButton.tintColor = UIColor.gridList
    }
    
    @objc func handleChangeToListView() {
        listButton.tintColor = .mainBlue()
        gridButton.tintColor = UIColor.gridList
        bookmarkButton.tintColor = UIColor.gridList
    }
    
    @objc func handleChangeToBookmark() {
        bookmarkButton.tintColor = .mainBlue()
        gridButton.tintColor = UIColor.gridList
        listButton.tintColor = UIColor.gridList
    }
    
    @objc func handleEditProfileOrFollow() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = self.user?.uid else { return }
        
        if editProfileOrFollowButton.titleLabel?.text == "Unfollow" {
            Database.database().reference().child("following").child(currentUserId).child(userId).removeValue { err, ref in
                if let err = err {
                    print("Failed to unfollow user: \(err)")
                }
                
                let attributedFollowersCount = NSMutableAttributedString(string: String("0"), attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
                let followersText = NSMutableAttributedString(string: "\nfollowers", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                attributedFollowersCount.append(followersText)
                self.followersLabel.attributedText = attributedFollowersCount
                
                self.setupTitleFollow()
                print("Succsesfully unfollowed user")
            }
        } else {
            let ref = Database.database().reference().child("following").child(currentUserId)
            let values = [userId: 1]
            ref.updateChildValues(values) { err, ref in
                if let err = err{
                    print("Failed to follow user: \(err)")
                }
                
                let attributedFollowersCount = NSMutableAttributedString(string: String("1"), attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
                let followersText = NSMutableAttributedString(string: "\nfollowers", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                attributedFollowersCount.append(followersText)
                self.followersLabel.attributedText = attributedFollowersCount
                
                self.setupTitleUnfollow()
                print("Successfully followed user")
            }
        }
    }
}
