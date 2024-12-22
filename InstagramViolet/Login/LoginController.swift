//
//  LoginController.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 08.12.2024.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {

    let emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Email"
        textField.textColor = .customThemeDarkText
        return textField
    }()
    
    let passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Password"
        textField.textColor = .customThemeDarkText
        return textField
    }()
    
    let signInButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Sign In", for: .normal)
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let attributedSignUp = NSMutableAttributedString(string: "Sign Up.",attributes: [NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)])
        attributedText.append(attributedSignUp)
        button.setAttributedTitle(attributedText, for: .normal)
        return button
    }()
    
    let instagramLogo: UIView = {
        let view = UIView()
        let imageInstagramLogo = UIImageView(image: UIImage.instagramLogoWhite)
        imageInstagramLogo.contentMode = .scaleAspectFill
        view.addSubview(imageInstagramLogo)
        imageInstagramLogo.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, paddingTop: 0, paddingLeading: 0, paddingTrailing: 0, paddingBottom: 0, width: 300, height: 40)
        imageInstagramLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageInstagramLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.backgroundColor = UIColor.systemBlue
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        signInButton.addGestureRecognizer(tapGesture)
        setupUI()
        setupInputFields()
        setupTarget()
    }

    private func setupUI() {
        view.backgroundColor = .customThemeDark
        view.addSubviews(signUpButton, instagramLogo)
        
        signUpButton.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, paddingTop: 0, paddingLeading: 0, paddingTrailing: 0, paddingBottom: -16, width: 0, height: 50)
        instagramLogo.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, paddingTop: 0, paddingLeading: 0, paddingTrailing: 0, paddingBottom: 0, width: 0, height: 250)
    }
    
    private func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, signInButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = .spacing16
        view.addSubview(stackView)
        
        stackView.anchor(top: instagramLogo.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, paddingTop: .spacing64, paddingLeading: .spacing40, paddingTrailing: -.spacing40, paddingBottom: 0, width: 0, height: 180)
    }
    
    private func setupTarget() {
        signUpButton.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        signInButton.addTarget(self, action: #selector(handleShowSignIn), for: .touchUpInside)
    }
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 >= 4 &&
        passwordTextField.text?.count ?? 0 >= 6
        
        if isFormValid {
            signInButton.isEnabled = true
            signInButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signInButton.isEnabled = false
            signInButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    @objc func handleShowSignIn() {
        guard let email = emailTextField.text, email.count >= 4 else { return }
        guard let password = passwordTextField.text, password.count >= 6 else { return }
        Auth.auth().signIn(withEmail: email, password: password) { user, err in
            if let err = err {
                print("Failed to sign in with email:", err)
                return
            }
            print("Successfully signed in with email:", user?.user.uid ?? "")
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let mainTabBarController = windowScene.windows.first?.rootViewController as? MainTabBarController {
                mainTabBarController.setupMainTabBarController()
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleShowSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
