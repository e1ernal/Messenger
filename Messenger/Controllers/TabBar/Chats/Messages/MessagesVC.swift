//
//  MessagesVC.swift
//  Messenger
//
//  Created by e1ernal on 15.03.2024.
//

import UIKit

enum MessageType {
    case message(MessageRow)
    case section(SectionRow)
}

struct MessageRow {
    let authorId: Int
    let message: String
    let date: Int
    let time: String
}

struct SectionRow {
    let sectionDate: String
}

class MessagesVC: UIViewController {
    internal var name: String
    internal var image: UIImage
    internal var chatId: Int
    internal var userId: Int
    
    internal var messages: [MessageType] = []
    
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
        
        sendButton.addTarget(self, action: #selector(sendMessageButton), for: .touchUpInside)
    }
    
    // MARK: - Init UIViewController
    init(name: String, image: UIImage, chatId: Int, userId: Int) {
        self.name = name
        self.image = image
        self.chatId = chatId
        self.userId = userId
        
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
        title = name
        view.backgroundColor = .color(.background)
        
        tabBarController?.tabBar.isHidden = true
        
        let height: CGFloat = 40
        
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: height).isActive = true
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        button.layer.cornerRadius = height * 0.5
        button.clipsToBounds = true
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
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
            messagesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
            self.scrollView.setContentOffset(CGPoint(x: 0, y: endFrame.height + .constant(.spacing)), animated: false)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let animationCurveRawValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else {
            return
        }
        
        let animationCurve = UIView.AnimationOptions(rawValue: UInt(animationCurveRawValue))
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: animationCurve,
                       animations: {
            self.scrollView.setContentOffset(.zero, animated: false)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: Send Message
    @objc private func sendMessageButton() {
        guard let message = messageTextField.text,
              !message.isEmpty else {
            return
        }
        
        Task {
            do {
                let token = try Storage.shared.get(service: .token, as: String.self, in: .account)
                let messageData = try await NetworkService.shared.sendMessage(chatId: chatId, token: token, message: message)
                
                let newMessage = MessageRow(authorId: messageData.author.id,
                                            message: messageData.text,
                                            date: messageData.createdAt,
                                            time: messageData.createdAt.toTime())
                
                let numberOfNewRows = configureMessages(with: newMessage)
                
                messagesTableView.scrollToBottom()
                
                // Inserting a rows at the end
                var indexPaths: [IndexPath] = []
                for rowNumber in 1...numberOfNewRows {
                    indexPaths.append(IndexPath(row: messages.count - rowNumber, section: 0))
                }
                
                messagesTableView.performBatchUpdates({
                    messagesTableView.insertRows(at: indexPaths, with: .fade)
                }, completion: nil)
                
                messageTextField.text = ""
                sendButton.tintColor = .inactive
            } catch {
                showSnackBar(text: error.localizedDescription, image: .systemImage(.warning, color: .label), on: self)
            }
        }
    }
    
    func configureMessages(with newMessage: MessageRow) -> Int {
        let messageTypeMessage: MessageType = .message(newMessage)
        
        let sectionRow = SectionRow(sectionDate: newMessage.date.toSectionDate())
        let messageTypeSection: MessageType = .section(sectionRow)
        
        if messages.isEmpty {
            messages.append(messageTypeSection)
            messages.append(messageTypeMessage)
            return 2
        }
        
        switch messages.last {
        case let .message(messageRow):
            if messageRow.date.toDateWithoutTime() != newMessage.date.toDateWithoutTime() {
                messages.append(messageTypeSection)
                messages.append(messageTypeMessage)
                return 2
            }
            
            messages.append(messageTypeMessage)
            return 1
        default:
            return 0
        }
    }
}

extension UITableView {
    // Scroll to bottom of TableView
    func scrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections - 1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}
