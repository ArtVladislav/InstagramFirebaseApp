//
//  FirebaseService.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 26.01.2025.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

protocol FirebaseServiceProtocol {
    func fetchUser(completion: @escaping (Result<User?, Error>) -> Void)
    func fetchPostsWithUser(completion: @escaping (Result<[LikedPost]?, Error>) -> Void)
}

class FirebaseService: FirebaseServiceProtocol {
    
    func fetchUser(completion: @escaping (Result<User?, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            completion(.success(user))
        } withCancel: { error in
            completion(.failure(error))
            print(" Failed to fetch User: \(error)")
        }
    }
    
    func fetchPostsWithUser(completion: @escaping (Result<[LikedPost]?, any Error>) -> Void) {
        fetchUser { user in
            //  Database.database().reference()
        }
        
    }
}
