//
//  CommentsCell.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 24.12.2024.
//

import UIKit
import FirebaseDatabase

class CommentsCell: UICollectionViewCell {
    
    static let cellId = "CommentsCell"
    
    let nameView: UILabel = {
        let nameView = UILabel()
        nameView.font = .systemFont(ofSize: 14)
        nameView.text = "Username"
        nameView.textColor = .customThemeDarkText
        nameView.backgroundColor = .customBlackWhite
        return nameView
    }()
    
    let textView: UITextView = {
       let textView = UITextView()
        textView.font = .systemFont(ofSize: 14)
        textView.text = "Comment..."
        textView.textColor = .customThemeDarkText
        textView.backgroundColor = .customThemeDark
        textView.layer.cornerRadius = 15
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = true
        return textView
    }()
    
    let imageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.backgroundColor = .customThemeDark
        return imageView
    }()
    
    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .systemGray
        return dateLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .customBlackWhite
        addSubviews(textView, imageView, nameView)
        imageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, paddingTop: 8, paddingLeading: 10, paddingTrailing: 0, paddingBottom: 0, width: 50, height: 50)
        nameView.anchor(top: topAnchor, leading: imageView.trailingAnchor, trailing: trailingAnchor, bottom: textView.topAnchor, paddingTop: 0, paddingLeading: 10, paddingTrailing: -10, paddingBottom: 0, width: 0, height: 28)
        textView.anchor(top: nameView.bottomAnchor, leading: imageView.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeading: 10, paddingTrailing: -10, paddingBottom: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with comment: Comment) {
        self.textView.text = comment.text
        self.dateLabel.text = comment.creationDate.timeAgoDisplay()
        Database.database().reference().child("users").child(comment.uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            guard let imageUrl = dictionaries["imageFileURL"] as? String else { return }
            guard let userName = dictionaries["username"] as? String else { return }
            self.nameView.text = userName
            self.imageView.loadImage(urlString: imageUrl)
        } withCancel: { err in
            print ("Failed to fetch User: \(err)")
        }
    }
}
