//
//  User.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 16.12.2024.
//


struct User {
    
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["imageFileURL"] as? String ?? ""
    }
}
