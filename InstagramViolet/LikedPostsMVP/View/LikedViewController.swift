//
//  LikedViewController.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 26.01.2025.
//

import UIKit

class LikedViewController: UIViewController {

    var presenter: LikedViewPresenterProtocol?
    var collectionView: UICollectionView!
    
    private let testButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Test button", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: UICollectionViewLayout())
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.backgroundColor = .clear
        view.backgroundColor = .systemBlue
        view.addSubview(collectionView)
        setupUI()
    }
    
    private func setupUI() {
        testButton.addTarget(self, action: #selector(handleTestButton), for: .touchUpInside)
        view.addSubview(testButton)
        testButton.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, paddingTop: 100, paddingLeading: 100, paddingTrailing: -100, paddingBottom: 0, width: 0, height: 70)
    }
    
    @objc private func handleTestButton() {
        self.presenter?.showLikedPosts()
    }
    
    
}

extension LikedViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = .black
        return cell
    }
    
}

extension LikedViewController: LikedViewProtocol {
    func setLikedPosts(likedPosts: LikedPost) {
        self.testButton.setTitle(likedPosts.caption, for: .normal)
    }
    
    
}
