//
//  UserProfileController.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 01.12.2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user: User?
    var posts = [Post]()
    var following = 0
    var followers = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .customBlackWhite
        navigationController?.navigationBar.tintColor = .customThemeDarkText
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UserProfileHeader.cellId)
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: UserProfilePhotoCell.cellId)
        fetchUser()
        setupLogOutButton()
    }
    
    private func fetchUser() {
        let uid = user?.uid ?? Auth.auth().currentUser?.uid ?? ""
        Database.fetchUserWithUid(uid: uid) { user in
            self.user = user
            self.navigationItem.title = self.user?.username
            self.collectionView.reloadData()
            self.fetchOrderedPost()
            self.fetchFollowing()
        }
    }
    
    private func fetchOrderedPost() {
        guard let uid = self.user?.uid else { return }
        Database.fetchUserWithUid(uid: uid) { user in
            let ref = Database.database().reference().child("posts").child(uid)
            ref.queryOrdered(byChild: "creationDate").observe(.childAdded) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                let post = Post(user: user, dictionary: dictionary)
                self.posts.insert(post, at: 0)
                self.collectionView.reloadData()
            }
        }
    }
    
    private func fetchFollowing() {
        guard let uid = self.user?.uid else { return }
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            self.following = dictionary.count
            print("following: \(self.following)")
            
            
        } withCancel: { err in
            print("Failed fetch followers: \(err)")
        }

        
    }
 
    private func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.gear.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfilePhotoCell.cellId, for: indexPath) as! UserProfilePhotoCell
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UserProfileHeader.cellId, for: indexPath ) as! UserProfileHeader
        guard let user = self.user else { return header }
        header.configure(user: user, postsCount: posts.count, followersCount: followers, followingCount: following)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 200)
    }
    
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            do {
                try Auth.auth().signOut()
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.show(navController, sender: nil)
            } catch let signOutError {
                print("Failed to sign out:", signOutError)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
