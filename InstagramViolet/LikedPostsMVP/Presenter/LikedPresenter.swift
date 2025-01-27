//
//  LikedPresenter.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 25.01.2025.
//
import Foundation

protocol LikedViewProtocol: AnyObject {
    func setLikedPosts(likedPosts: LikedPost)
}

protocol LikedViewPresenterProtocol: AnyObject {
    init(view: LikedViewProtocol, likedPost: LikedPost)
    func showLikedPosts()
}

class LikedPresenter: LikedViewPresenterProtocol {
    
    let view: LikedViewProtocol
    let likedPost: LikedPost
    
    required init(view: any LikedViewProtocol, likedPost: LikedPost) {
        self.view = view
        self.likedPost = likedPost
    }
    
    func showLikedPosts() {
        let likedPosts = self.likedPost
        self.view.setLikedPosts(likedPosts: likedPosts)
    }
}
