//
//  UserSearchController.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 16.12.2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    var users = [User]()
    var usersSearch = [User]()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.autocapitalizationType = .none
        sb.delegate = self
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        collectionView.addGestureRecognizer(tapGesture)
        
        let navBar = navigationController?.navigationBar
        navBar?.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, leading: navBar?.leadingAnchor, trailing: navBar?.trailingAnchor, bottom: navBar?.bottomAnchor, paddingTop: 0, paddingLeading: 8, paddingTrailing: -8, paddingBottom: 0, width: 0, height: 0)
        self.collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: UserSearchCell.cellId)
        collectionView.keyboardDismissMode = .onDrag
        fetchUsers()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        usersSearch = [User]()
        usersSearch = users.filter({ user in
            user.username.lowercased().contains(searchText.lowercased())
        })
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func fetchUsers() {
        let myKey = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").observeSingleEvent(of: .value) { snapshot in
            guard let usersDictionary = snapshot.value as? [String: [String : Any]] else { return }
            usersDictionary.forEach { (key, value) in
                if myKey == key { return }
                let user = User(uid: key, dictionary: value)
                self.users.append(user)
            }
            self.users.sort { u1, u2 in
                u1.username.compare(u2.username) == .orderedAscending
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
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        let user = usersSearch[indexPath.item]
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.user = user
        self.show(userProfileController, sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if usersSearch.isEmpty && searchBar.text == "" { usersSearch = users }
        return usersSearch.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserSearchCell.cellId, for: indexPath) as! UserSearchCell
        if usersSearch.isEmpty && searchBar.text == "" { usersSearch = users }
        cell.configure(user: usersSearch[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
