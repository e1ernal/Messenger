//
//  MessagesVC.swift
//  Messenger
//
//  Created by e1ernal on 15.03.2024.
//

import UIKit

class MessagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    private var messages: [String] = []
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    private let messagesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let sendButton: UIButton = {
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
    
    private let messageTextField: UITextField = {
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
    
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
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
    
    // MARK: - Configure TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier,
                                                       for: indexPath) as? MessageCell else {
            fatalError("Error: The TableView could not dequeue a \(MessageCell.identifier)")
        }
        
        cell.configure(message: messages[indexPath.row],
                       side: indexPath.row.isMultiple(of: 3) ? .left : .right,
                       superViewWidth: view.frame.width,
                       time: "12:55")
        return cell
    }
    
    private func configureTableView() {
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
        messagesTableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.identifier)
        configureMessages()
    }
    
    private func configureMessages() {
        messages.append("Message 1 Message Message Message Message Message Message")
        messages.append("Short Message")
        messages.append("Message 2 Message Message Message Message Message Message")
        messages.append("Message 3 Message Message Message Message Message Message")
        messages.append("Medium size message with many letters")
        messages.append("Message 4 Message Message Message Message Message Message")
        messages.append("Message 5 Message Message Message Message Message Message Message Message Message Message")
        messages.append("Message 6 Message Message Message Message Message Message")
        messages.append("Message 6 Message Message Message Message Message Message")
        messages.append("Message 6 Message Message Message Message Message Message")
        messages.append("Message 6 Message Message Message Message Message Message")
        messages.append("Message 6 Message Message Message Message Message Message")
    }
    
    // MARK: - Configure TextField
    private func configureTextField() {
        messageTextField.delegate = self
        messageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text,
              !text.isEmpty else {
            sendButton.tintColor = .inactive
            return
        }
        
        sendButton.tintColor = .active
    }
    
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
        }, completion: nil)
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
