//
//  ProfileInfo.swift
//  Messenger
//
//  Created by e1ernal on 17.12.2023.
//

import Foundation
import UIKit

class ProfileInfoVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    private var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constraint.height.rawValue * 1.5
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile Info"
        label.font = Font.title.font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your name and add a profile picture"
        label.numberOfLines = 0
        label.font = Font.subtitle.font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var firstNameField = FloatingTextField(placeholder: "First name (required)")
    private var lastNameField = FloatingTextField(placeholder: "Last name (optional)")
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = Font.button.font
        button.backgroundColor = Color.inactive.color
        button.heightAnchor.constraint(equalToConstant: Constraint.height.rawValue).isActive = true
        button.layer.cornerRadius = Constraint.height.rawValue / 5
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constraint.spacing.rawValue
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImagePickerControllerActionSheet)))
        makeUI()
        hideKeyboardWhenTappedAround()
    }
    
    private func makeUI() {
        view.backgroundColor = Color.background.color
        navigationItem.setHidesBackButton(true, animated: true)
        
        firstNameField.translatesAutoresizingMaskIntoConstraints = false
        lastNameField.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)
        stack.setCustomSpacing(Constraint.spacing.rawValue * 2, after: subtitleLabel)
        stack.addArrangedSubview(firstNameField)
        stack.addArrangedSubview(lastNameField)
        stack.setCustomSpacing(Constraint.spacing.rawValue * 2, after: lastNameField)
        stack.addArrangedSubview(continueButton)
        
        view.addSubview(profileImage)
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: Constraint.height.rawValue * 3),
            profileImage.widthAnchor.constraint(equalToConstant: Constraint.height.rawValue * 3),
            
            stack.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: Constraint.spacing.rawValue)
        ])
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.hasText {
            guard let floatingTextfield = textField as? FloatingTextField else { return }
            floatingTextfield.changeVisibility(isActive: true)
            if textField === firstNameField {
                UIView.animate(withDuration: 0.25) {
                    self.continueButton.backgroundColor = Color.active.color
                }
            }
        } else {
            guard let floatingTextfield = textField as? FloatingTextField else { return }
            floatingTextfield.changeVisibility(isActive: false)
            if textField === firstNameField {
                UIView.animate(withDuration: 0.25) {
                    self.continueButton.backgroundColor = Color.inactive.color
                }
            }
        }
    }
    
    @objc
    func continueButtonTapped() {
        guard firstNameField.hasText,
              let firstName = firstNameField.text else {
            print("NO User name")
            return
        }
        
        print("Username: \(String(describing: ""))")
        print("First name: \(String(describing: firstName))")
        print("Last name: \(String(describing: lastNameField.text))")
        print("Image: \(String(describing: profileImage.image))")
        
        let nextVC = UsernameVC()
        nextVC.firstName = firstName
        nextVC.lastName = lastNameField.text
        nextVC.profileImage = profileImage.image
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
            profileImage.image = editedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
