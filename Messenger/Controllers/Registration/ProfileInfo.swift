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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile Info"
        label.font = .font(.title)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your name and add a profile picture"
        label.numberOfLines = 0
        label.font = .font(.subtitle)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var firstNameTextField = FloatingTextField(placeholder: "First name (required)")
    private var lastNameTextField = FloatingTextField(placeholder: "Last name (optional)")
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = .font(.button)
        button.backgroundColor = .color(.inactive)
        button.heightAnchor.constraint(equalToConstant: .constant(.height)).isActive = true
        button.layer.cornerRadius = .constant(.cornerRadius)
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        
//        userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImagePickerControllerActionSheet)))
        
        setupUI()
    }
    
    private func setupUI() {
        setupVC(title: "", backButton: false)
        
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
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
        if textField.hasText {
            guard let floatingTextfield = textField as? FloatingTextField else { return }
            floatingTextfield.changeVisibility(isActive: true)
            if textField === firstNameTextField {
                UIView.animate(withDuration: 0.25) {
                    self.continueButton.backgroundColor = .color(.active)
                }
            }
        } else {
            guard let floatingTextfield = textField as? FloatingTextField else { return }
            floatingTextfield.changeVisibility(isActive: false)
            if textField === firstNameTextField {
                UIView.animate(withDuration: 0.25) {
                    self.continueButton.backgroundColor = .color(.inactive)
                }
            }
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
                                               style: .default) { _ in
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
