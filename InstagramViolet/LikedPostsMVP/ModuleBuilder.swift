//
//  ModuleBuilder.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 26.01.2025.
//
import UIKit

protocol Builder {
    static func createLikedPosts() -> UIViewController
}

class ModuleBuilder: Builder {
    static func createLikedPosts() -> UIViewController {
        let likedPost = LikedPost(imageUrl: nil, user: nil, caption: "Good", creationDate: nil)
        let view = LikedCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        let view = LikedViewController()
        let presenter = LikedPresenter(view: view, likedPost: likedPost)
        view.presenter = presenter
        return view
    }
    
    
}
