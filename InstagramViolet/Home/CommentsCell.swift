//
//  CommentsCell.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 24.12.2024.
//

import UIKit

class CommentsCell: UICollectionViewCell {
    
    static let cellId = "CommentsCell"
    
    let textView: UITextView = {
       let textView = UITextView()
        textView.font = .systemFont(ofSize: 14)
        textView.text = "Hello"
        textView.textColor = .customThemeDarkText
        textView.backgroundColor = .none
        return textView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.backgroundColor = .green
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .customThemeDark
        addSubviews(textView, imageView)
        imageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, paddingTop: 10, paddingLeading: 10, paddingTrailing: 0, paddingBottom: -10, width: 60, height: 60)
        textView.anchor(top: topAnchor, leading: imageView.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, paddingTop: 10, paddingLeading: 20, paddingTrailing: -10, paddingBottom: -10, width: 0, height: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
