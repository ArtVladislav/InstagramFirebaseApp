//
//  FirebaseUtils.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 16.12.2024.
//


import FirebaseAuth
import FirebaseDatabase

extension Database {
    static func fetchUserWithUid(uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot  in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
        } withCancel: { err in
            print("Failed to fetch user for posts: ", err)
        }
    }
}