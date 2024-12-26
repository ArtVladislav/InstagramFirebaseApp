//
//  CommentsCell.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 24.12.2024.
//

import UIKit

class CommentsCell: UICollectionViewCell {
    
    static let cellId = "CommentsCell"
    
    let nameView: UITextView = {
        let nameView = UITextView()
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
        return textView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.backgroundColor = .customThemeDark
        return imageView
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
}
