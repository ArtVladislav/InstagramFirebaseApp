//
//  Comment.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 27.12.2024.
//
import Foundation

class Comment {
    
    let text: String
    let uid: String
    let creationDate: Date
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
