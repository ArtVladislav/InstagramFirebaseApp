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
        nameView.font = .boldSystemFont(ofSize: 14)
        nameView.text = "Username"
        nameView.textColor = .customThemeDarkText
        nameView.backgroundColor = UIColor.clear
        return nameView
    }()
    
    let textView: UITextView = {
       let textView = UITextView()
        textView.font = .systemFont(ofSize: 13)
        textView.text = "Comment..."
        textView.textColor = .customThemeDarkText
        textView.backgroundColor = .customThemeComments
        textView.layer.cornerRadius = 15
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let imageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.customThemeGray.cgColor
        imageView.layer.cornerRadius = 23
        imageView.clipsToBounds = true
        imageView.backgroundColor = .customThemeComments
        return imageView
    }()
    
    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .customThemeGray
        dateLabel.backgroundColor = UIColor.clear
        return dateLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        
        addSubviews(textView, imageView, nameView, dateLabel)
        imageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, paddingTop: 4, paddingLeading: 10, paddingTrailing: 0, paddingBottom: 0, width: 46, height: 46)
        dateLabel.anchor(top: topAnchor, leading: nil, trailing: textView.trailingAnchor, bottom: textView.topAnchor, paddingTop: 0, paddingLeading: 0, paddingTrailing: -16, paddingBottom: 0, width: 0, height: 20)
        nameView.anchor(top: topAnchor, leading: textView.leadingAnchor, trailing: trailingAnchor, bottom: textView.topAnchor, paddingTop: 0, paddingLeading: 8, paddingTrailing: -10, paddingBottom: 0, width: 0, height: 20)
        textView.anchor(top: nameView.bottomAnchor, leading: imageView.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeading: 10, paddingTrailing: -40, paddingBottom: 0, width: 0, height: 0)
        
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
