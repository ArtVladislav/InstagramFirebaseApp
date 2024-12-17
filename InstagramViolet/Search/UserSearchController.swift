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
    var usersSearch = [User]()
    
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.autocapitalizationType = .none
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navBar = navigationController?.navigationBar
        navBar?.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, leading: navBar?.leadingAnchor, trailing: navBar?.trailingAnchor, bottom: navBar?.bottomAnchor, paddingTop: 0, paddingLeading: 8, paddingTrailing: -8, paddingBottom: 0, width: 0, height: 0)
        self.collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: UserSearchCell.cellId)
        searchBar.searchTextField.addTarget(self, action: #selector(handleSearchBar), for: .editingChanged)
        fetchUsers()
        collectionView.alwaysBounceVertical = true
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
        let count: Int
        (usersSearch.isEmpty && searchBar.text == "") ? (count = users.count) : (count = usersSearch.count)
        return count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserSearchCell.cellId, for: indexPath) as! UserSearchCell
        let array: [User]
        (usersSearch.isEmpty && searchBar.text == "") ? (array = users) : (array = usersSearch)
        cell.configure(user: array[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    @objc func handleSearchBar() {
        guard let text = searchBar.text else { return }
        usersSearch = [User]()
        
        usersSearch = users.filter({ user in
            user.username.lowercased().contains(text.lowercased())
        })
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    

}
