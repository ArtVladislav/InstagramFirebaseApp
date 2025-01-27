//
//  LikedPost.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 25.01.2025.
//
import Foundation

struct LikedPost {
    var id: String?
    let imageUrl: String?
    let user: User?
    let caption: String
    let creationDate: Date?
    
    var hasLiked = false
}
