//
//  ProfileInfo.swift
//  Messenger
//
//  Created by e1ernal on 17.12.2023.
//

import Foundation
import UIKit

class ProfileInfoVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = .constant(.imageCornerRadius)
        imageView.image = UIImage(named: "addPhoto")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, 
                                                              action: #selector(showImagePickerControllerActionSheet)))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel = BasicLabel("Profile Info", .font(.title))
    private let subtitleLabel = BasicLabel("Enter your name and add a profile picture", .font(.subtitle))
    
    private var firstNameTextField = FloatingTextField(placeholder: "First name (required)")
    private var lastNameTextField = FloatingTextField(placeholder: "Last name (optional)")
    
    private lazy var continueButton = BasicButton(title: "Continue", style: .filled(.inactive)) {
        self.continueButtonTapped()
    }
    
    private lazy var uiStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = .constant(.spacing)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        setupUI()
    }
    
    private func setupUI() {
        setupVC(title: "", backButton: false)
        
        uiStackView.addArrangedSubview(titleLabel)
        uiStackView.addArrangedSubview(subtitleLabel)
        uiStackView.setCustomSpacing(.constant(.doubleSpacing), after: subtitleLabel)
        uiStackView.addArrangedSubview(firstNameTextField)
        uiStackView.addArrangedSubview(lastNameTextField)
        uiStackView.setCustomSpacing(.constant(.doubleSpacing), after: lastNameTextField)
        uiStackView.addArrangedSubview(continueButton)
        
        view.addSubview(userImageView)
        view.addSubview(uiStackView)
        
        NSLayoutConstraint.activate([
            userImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userImageView.heightAnchor.constraint(equalToConstant: .constant(.imageHeight)),
            userImageView.widthAnchor.constraint(equalToConstant: .constant(.imageHeight)),
            
            uiStackView.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            uiStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uiStackView.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: .constant(.spacing))
        ])
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let textField = textField as? FloatingTextField else {
            return
        }
        
        let fieldState: ViewState = textField.hasText ? .active : .inactive
        textField.setState(fieldState)
        
        if textField === firstNameTextField {
            continueButton.setState(textField.hasText ? .active : .inactive)
        }
    }
    
    @objc
    func continueButtonTapped() {
        guard firstNameTextField.hasText,
              let firstName = firstNameTextField.text else {
            print("NO User name")
            return
        }
        
        guard let image = userImageView.image else {
            print("NO image")
            return
        }
        
        let nextVC = UsernameVC(firstName: firstName, lastName: lastNameTextField.text, profileImage: image)
        showNextVC(nextVC: nextVC)
    }
    
    // MARK: - Image Picker Controller Actions
    @objc
    func showImagePickerControllerActionSheet() {
        let photoLibraryAction = UIAlertAction(title: "Open Gallery",
                                               style: .default) {_ in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "Take a photo",
                                         style: .default) { _ in
            self.showImagePickerController(sourceType: .camera)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        let alert = UIAlertController()
        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            userImageView.image = editedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
