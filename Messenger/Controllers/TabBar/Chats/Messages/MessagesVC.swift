//
//  MessagesVC.swift
//  Messenger
//
//  Created by e1ernal on 15.03.2024.
//

import UIKit

class MessagesVC: UIViewController {
    internal var name: String
    internal var image: String
    internal var chatId: String
    
    internal var messages: [String: [Message]] = [:]
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    internal let messagesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    internal let sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = (.constant(.height) - 2 * .constant(.halfSpacing)) * 0.5
        button.setImage(.systemImage(.sendButton, color: .inactive).withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .inactive
        button.imageView?.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    internal let messageTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.color(.inactive),
            NSAttributedString.Key.font: UIFont.font(.subtitle)
        ]
        
        textField.attributedPlaceholder = NSAttributedString(string: "Message", attributes: attributes)
        
        return textField
    }()
    
    private let sendMessageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundSecondary
        view.layer.cornerRadius = .constant(.height) * 0.5
        return view
    }()
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureTextField()
        configureUI()
        // Observe keyboard change
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    // MARK: - Init UIViewController
    init(name: String, image: String, chatId: String) {
        self.name = name
        self.image = image
        self.chatId = chatId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Deinit UIViewController
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        configureVC(title: "Messages", backButton: true)
        tabBarController?.tabBar.isHidden = true
        
        setupScrollView()
        setupViews()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        scrollView.isScrollEnabled = false
    }
    
    private func setupViews() {
        sendMessageView.addSubview(messageTextField)
        sendMessageView.addSubview(sendButton)
        contentView.addSubview(sendMessageView)
        
        NSLayoutConstraint.activate([
            sendMessageView.heightAnchor.constraint(equalToConstant: .constant(.height)),
            sendMessageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            sendMessageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .constant(.spacing)),
            sendMessageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.constant(.spacing)),
            
            sendButton.trailingAnchor.constraint(equalTo: sendMessageView.trailingAnchor, constant: -.constant(.halfSpacing)),
            sendButton.centerYAnchor.constraint(equalTo: sendMessageView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: .constant(.height) - 2 * .constant(.halfSpacing)),
            sendButton.heightAnchor.constraint(equalToConstant: .constant(.height) - 2 * .constant(.halfSpacing)),
            
            messageTextField.leadingAnchor.constraint(equalTo: sendMessageView.leadingAnchor, constant: .constant(.height) * 0.5),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -.constant(.halfSpacing)),
            messageTextField.topAnchor.constraint(equalTo: sendMessageView.topAnchor, constant: .constant(.halfSpacing)),
            messageTextField.bottomAnchor.constraint(equalTo: sendMessageView.bottomAnchor, constant: -.constant(.halfSpacing))
        ])
        
        contentView.addSubview(messagesTableView)
        
        NSLayoutConstraint.activate([
            messagesTableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            messagesTableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            messagesTableView.bottomAnchor.constraint(equalTo: sendMessageView.topAnchor, constant: -.constant(.spacing)),
            messagesTableView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    // MARK: - Keyboard Notifications
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let animationCurveRawValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else {
            return
        }
        
        let animationCurve = UIView.AnimationOptions(rawValue: UInt(animationCurveRawValue))
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: animationCurve,
                       animations: {
            self.scrollView.contentOffset.y += endFrame.height + .constant(.spacing)
        }, completion: { _ in
            self.messagesTableView.scrollToBottom()
        })
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let animationCurveRawValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else {
            return
        }
        
        let animationCurve = UIView.AnimationOptions(rawValue: UInt(animationCurveRawValue))
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: animationCurve,
                       animations: {
            self.scrollView.contentOffset.y -= endFrame.height + .constant(.spacing)
        }, completion: nil)
    }
}

extension UITableView {
    func scrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
            let numberOfSections = self.numberOfSections
            guard numberOfSections > 0 else { return }
            
            let numberOfRows = self.numberOfRows(inSection: numberOfSections - 1)
            guard numberOfRows > 0 else { return }
            
            let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
}
