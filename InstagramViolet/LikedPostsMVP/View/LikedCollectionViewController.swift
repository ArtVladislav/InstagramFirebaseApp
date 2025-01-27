//
//  LikedCollectionViewController.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 25.01.2025.
//

import UIKit

private let reuseIdentifier = "Cell"

class LikedCollectionViewController: UICollectionViewController {

    var presenter: LikedViewPresenterProtocol?
    
    let testButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customThemeComments
        button.setTitle("Test button", for: .normal)
        button.setTitleColor(.customThemeDarkText, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .customThemeGray
        setupUI()
    }

    private func setupUI() {
        testButton.addTarget(self, action: #selector(handleTestButton), for: .touchUpInside)
        view.addSubview(testButton)
        testButton.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, paddingTop: 100, paddingLeading: 100, paddingTrailing: -100, paddingBottom: 0, width: 0, height: 70)
    }
    
    @objc func handleTestButton() {
        self.presenter?.showLikedPosts()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .customThemeComments
        return cell
    }
    
}

extension LikedCollectionViewController: LikedViewProtocol{
    func setLikedPosts(likedPosts: LikedPost) {
        self.testButton.setTitle(likedPosts.caption, for: .normal)
    }
}
