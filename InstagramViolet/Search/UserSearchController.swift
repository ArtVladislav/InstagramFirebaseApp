//
//  UserSearchController.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 16.12.2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: UserSearchCell.cellId)
        fetchUsers()
    }

    private func fetchUsers() {
        Database.database().reference().child("users").observeSingleEvent(of: .value) { snapshot in
            guard let usersDictionary = snapshot.value as? [String: [String : Any]] else { return }
            usersDictionary.forEach { (key, value) in
                let user = User(uid: key, dictionary: value)
                self.users.append(user)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } withCancel: { err in
            print("Failed to fetch users: \(err)")
        }
        
    }
    
    // MARK: - Navigation

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return users.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserSearchCell.cellId, for: indexPath) as! UserSearchCell
        cell.configure(user: users[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    // MARK: UICollectionViewDelegate

    

}
