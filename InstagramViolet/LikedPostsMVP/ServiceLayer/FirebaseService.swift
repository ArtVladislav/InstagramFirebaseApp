//
//  FirebaseService.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 26.01.2025.
//

import Foundation
protocol FirebaseServiceProtocol {
    func fetchPosts(completion: @escaping (Result<[LikedPost]?, Error>) -> Void)
}

class FirebaseService: FirebaseServiceProtocol {
    func fetchPosts(completion: @escaping (Result<[LikedPost]?, any Error>) -> Void) {
        
    }
    
}
