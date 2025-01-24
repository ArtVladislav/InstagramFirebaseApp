//
//  SignUpController.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 25.11.2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let attributedSignUp = NSMutableAttributedString(string: "Sign In.",attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        attributedText.append(attributedSignUp)
        button.setAttributedTitle(attributedText, for: .normal)
        return button
    }()
    
    let plusFotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Photo", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .customThemeDark
        button.layer.cornerRadius = .spacing64
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Email"
        textField.textColor = .customThemeDarkText
        return textField
    }()
    
    let userNameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "User Name"
        textField.textColor = .customThemeDarkText
        return textField
    }()
    
    let passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Password"
        textField.textColor = .customThemeDarkText
        return textField
    }()
    
    let signUpButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Sign Up", for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .customThemeDark
        setupButton()
        setupTarget()
    }
    
    private func setupButton() {
        view.addSubviews(plusFotoButton, signInButton)
        setupConstrains()
        setupInputFields()
        
    }
    
    private func setupTarget() {
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        plusFotoButton.addTarget(self, action: #selector(handlePlusFoto), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        signInButton.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
    }
    
    private func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, userNameTextField, passwordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = .spacing16
        
        view.addSubview(stackView)
        
        stackView.anchor(top: plusFotoButton.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, paddingTop: .spacing64, paddingLeading: .spacing40, paddingTrailing: -.spacing40, paddingBottom: 0, width: 0, height: 240)
        
    }
    
    private func setupConstrains() {
        
        NSLayoutConstraint.activate([
            plusFotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: .spacing72),
            plusFotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plusFotoButton.heightAnchor.constraint(equalToConstant: .spacing128),
            plusFotoButton.widthAnchor.constraint(equalTo: plusFotoButton.heightAnchor)
        ])
        
        signInButton.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, paddingTop: 0, paddingLeading: 0, paddingTrailing: 0, paddingBottom: -16, width: 0, height: 50)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            plusFotoButton.setImage(editedImage, for: .normal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            plusFotoButton.setImage(originalImage, for: .normal)
        }
        dismiss(animated: true)
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error)")
                // complition(.failure(error))
                return
            }
            guard let data = data else { return }
            
//            complition(.sucsess(data))
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.plusFotoButton.setImage(image, for: .normal)
            }
        }
        task.resume()
    }
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 >= 4 &&
        userNameTextField.text?.count ?? 0 >= 4 &&
        passwordTextField.text?.count ?? 0 >= 6
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    @objc func handlePlusFoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleShowSignUp() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text, email.count >= 4 else { return }
        guard let username = userNameTextField.text, username.count >= 4 else { return }
        guard let password = passwordTextField.text, password.count >= 6 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Ошибка: \(error.localizedDescription)")
                return
            }
            print("Пользователь успешно зарегистрирован: \(result?.user.uid ?? "")")
            
            guard let image = self.plusFotoButton.imageView?.image else { return }
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            
            let filename = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_image").child(filename)
            
            storageRef.putData(uploadData, metadata: nil) { metadata, err in
                if let err = err {
                    print("Failed to upload profile image:", err)
                    return
                }
                
                storageRef.downloadURL { url, err in
                    if let error = error {
                        print("Failed to get download URL:", error)
                        return
                    }
                    if let url = url {
                        print("Successfully uploaded profile image. URL: \(url.absoluteString)")
                        
                        guard let uid = result?.user.uid else { return }
                        let dictionaryValues = ["username" : username, "imageFileURL" : url.absoluteString]
                        let values = [uid : dictionaryValues]
                        
                        Database.database().reference().child("users").updateChildValues(values) { err, ref in
                            if let err = err {
                                print("Failed to save user info into db:", err)
                                return
                            }
                            
                            self.emailTextField.text = ""
                            self.userNameTextField.text = ""
                            self.passwordTextField.text = ""
                            print("Succesfully saved use info into db")
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let mainTabBarController = windowScene.windows.first?.rootViewController as? MainTabBarController {
                                mainTabBarController.setupMainTabBarController()
                            }
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                    }
                    
                }
            }
            
        }
    }
}
