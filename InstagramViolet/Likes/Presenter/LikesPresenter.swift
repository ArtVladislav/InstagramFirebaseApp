//
//  LikesPresenter.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 25.01.2025.
//
import Foundation

protocol LikesViewProtocol: AnyObject {
    func setGreeeting( greeting: String)
}

protocol LikesViewPresenterProtocol: AnyObject {
    init(view: LikesViewProtocol, likesPost: LikesPost)
    func showGreeting()
}

class LikesPresenter: LikesViewPresenterProtocol {
    
    let view: LikesViewProtocol
    let likesPost: LikesPost
    
    required init(view: any LikesViewProtocol, likesPost: LikesPost) {
        self.view = view
        self.likesPost = likesPost
    }
    
    func showGreeting() {
        let greeting = self.likesPost.user.username
        self.view.setGreeeting(greeting: greeting)
    }
}
