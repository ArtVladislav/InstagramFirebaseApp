//
//  SharePhotoController.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 11.12.2024.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class SharePhotoController: UIViewController {

    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .customThemeDark
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.layer.cornerRadius = 20
        tv.clipsToBounds = true
        tv.backgroundColor = .customThemeDark
        tv.textColor = .customThemeDarkText
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBlackWhite
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        navigationController?.navigationBar.tintColor = UIColor.customThemeDarkText
        setupImageAndText()
    }
    
    private func setupImageAndText() {
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.backgroundColor = .customThemeDark
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, paddingTop: 0, paddingLeading: 0, paddingTrailing: 0, paddingBottom: 0, width: 0, height: 100)
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, trailing: nil, bottom: containerView.bottomAnchor, paddingTop: 0, paddingLeading: 0, paddingTrailing: 0, paddingBottom: 0, width: 100, height: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, leading: imageView.trailingAnchor, trailing: containerView.trailingAnchor, bottom: containerView.bottomAnchor, paddingTop: 0, paddingLeading: 0, paddingTrailing: 0, paddingBottom: 0, width: 0, height: 0)
    }
    
    private func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let postImage = selectedImage else { return }
        let caption = textView.text ?? ""
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        ref.updateChildValues(values) { err, ref in
            if let err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Error saving post: \(err)")
                return
            }
            print("Post saved successfully to DB")
            self.dismiss(animated: true)
    
            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
        }
    }
    
    @objc func handleShare() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let image = selectedImage else { return }
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(filename)
        storageRef.putData(uploadData, metadata: nil) { metadata, err in
            if let err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Error uploading image: \(err)")
                return
            }
            storageRef.downloadURL { url, err in
                if let url = url {
                    print("Cool, Uploaded image:", url.absoluteString )
                    self.saveToDatabaseWithImageUrl(imageUrl: url.absoluteString )
                }
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
