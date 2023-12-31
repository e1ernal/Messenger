//
//  ViewController.swift
//  Messenger
//
//  Created by e1ernal on 21.11.2023.
//

import UIKit

enum ViewControllers {
    case phone
    case phoneConfirm
    case profileInfo
    case tabBar

    var getTitle: String {
        switch self {
        case .phone:
            return "Phone"
        case .phoneConfirm:
            return "Phone Confirm"
        case .profileInfo:
            return "Profile Info"
        case .tabBar:
            return "Tab Bar"
        }
    }

    var getClass: UIViewController {
        switch self {
        case .phone:
            return PhoneVC()
        case .phoneConfirm:
            return PhoneConvirmVC()
        case .profileInfo:
            return ProfileInfoVC()
        case .tabBar:
            return TabBarController()
        }
    }
}

class StartVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    private let vcArray: [ViewControllers] = [.phone, .phoneConfirm, .profileInfo, .tabBar]
    private let pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go", for: .normal)
        button.titleLabel?.font = Font.button.font
        button.backgroundColor = Color.active.color
        button.heightAnchor.constraint(equalToConstant: Constraint.height.rawValue).isActive = true
        button.layer.cornerRadius = Constraint.height.rawValue / 5
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var actionsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constraint.spacing.rawValue
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self

        makeUI()
    }

    private func makeUI() {
        title = "Navigation"
        view.backgroundColor = Color.background.color

        actionsStack.addArrangedSubview(pickerView)
        actionsStack.addArrangedSubview(continueButton)
        view.addSubview(actionsStack)

        NSLayoutConstraint.activate([
            actionsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            actionsStack.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3)
        ])
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return vcArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vcArray[row].getTitle
    }

    @objc 
    func continueButtonTapped() {
        let nextVC = vcArray[pickerView.selectedRow(inComponent: 0)].getClass
        showNextVC(nextVC: nextVC)
    }
}
