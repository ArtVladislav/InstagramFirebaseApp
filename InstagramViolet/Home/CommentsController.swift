//
//  CommentsController.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 24.12.2024.
//

import UIKit

private let reuseIdentifier = "Cell"

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .customThemeDark
        return containerView
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.send2, for: .normal)
        return button
    }()
    
    let textField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Enter comment..."
        textField.backgroundColor = .customBlackWhite
        textField.layer.cornerRadius = 18
        textField.clipsToBounds = true
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(CommentsCell.self, forCellWithReuseIdentifier: CommentsCell.cellId)
        view.addSubview(containerView)
        containerView.frame = CGRect(x: 0, y: view.frame.height - 80, width: view.frame.width, height: 80)
        setupInitialStateNotificationCenter()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupUI() {
        containerView.addSubviews(textField, submitButton)
        textField.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, trailing: submitButton.leadingAnchor, bottom: containerView.bottomAnchor, paddingTop: 4, paddingLeading: 16, paddingTrailing: -8, paddingBottom: -40, width: 0, height: 40)
        submitButton.anchor(top: containerView.topAnchor, leading: textField.trailingAnchor, trailing: containerView.trailingAnchor, bottom: containerView.bottomAnchor, paddingTop: 4, paddingLeading: 0, paddingTrailing: -10, paddingBottom: -40, width: 40, height: 40)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentsCell.cellId, for: indexPath) as! CommentsCell
    
        // Configure the cell
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 1
//    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
   
}

