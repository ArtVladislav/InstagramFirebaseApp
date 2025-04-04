//
//  HomeController.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 15.12.2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
        view.backgroundColor = .customBlackWhite
        self.collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: HomePostCell.cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        setupNavigationItem()
        fetchAllPosts()
    }

    private func setupNavigationItem() {
        navigationItem.titleView = UIImageView(image: UIImage.logo2)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.camera3.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    // MARK: - Navigation
    private func fetchAllPosts() {
        fetchOrderedPost()
        fetchPostsOtherUsers()
    }
    
    private func fetchPostsOtherUsers() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value) { snapshot in
            self.collectionView.refreshControl?.endRefreshing()
            guard let followingDictionary = snapshot.value as? [String: Any] else { return }
            followingDictionary.forEach { key, value in
                Database.fetchUserWithUid(uid: key) { user in
                    self.fetchPostsWithUser(user: user)
                }
            }
        } withCancel: { err in
            print( "Failed to fetch posts other users: \(err)")
        }
    }
    
    private func fetchOrderedPost() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUid(uid: uid) { user in
            self.fetchPostsWithUser(user: user)
        }
    }
     
    private func fetchPostsWithUser(user: User) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let dictionary = snapshot.value as? [String: [String: Any]] else { return }
            dictionary.forEach { key, value in
                var post = Post(user: user, dictionary: value)
                post.id = key
                
                Database.database().reference().child("likes").child(key).child(user.uid).observeSingleEvent(of: .value) { snapshot in
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    self.posts.insert(post, at: 0)
                    self.posts.sort { (p1,p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    }
                    self.collectionView.reloadData()
                } withCancel: { err in
                    print("Failed to fetch likes: \(err)")
                }
            }
        }, withCancel: { err in
            print("Filed to fetch posts: \(err)")
        })
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePostCell.cellId, for: indexPath) as! HomePostCell
        cell.delegate = self
        if (indexPath.item <= posts.count) {
            cell.configure(post: posts[indexPath.item])
        }
        return cell
    }
    
    //TODO: use this
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: width + 186)
    }
    
    func didTapComment(post: Post) {
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    func didLike(for cell: HomePostCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var post = self.posts[indexPath.item]
        
        guard let postId = post.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [uid: post.hasLiked == true ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { err, _ in
            if let err = err {
                print("Failed to like post: \(err)")
            }
            post.hasLiked = !post.hasLiked
            self.posts[indexPath.item] = post
            self.collectionView.reloadItems(at: [indexPath])
            print("Successfully liked post")
        }
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchAllPosts()
    }
    
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc func handleCamera() {
        let cameraController = CameraController()
        cameraController.modalPresentationStyle = .fullScreen
        present(cameraController, animated: true)
    }
    
    // MARK: UICollectionViewDelegate

}
