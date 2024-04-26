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

enum Side: Int, Codable {
    case left = 0
    case right = 1
}

enum RoundType: Int, Codable {
    case start = 0
    case between = 1
    case end = 2
    case startEnd = 3
}

struct MessageRow: Codable {
    var type = "message"
    let authorId: Int
    let message: String
    let date: Int
    let time: String
    let side: Side
    var roundType: RoundType
}

struct SectionRow {
    let sectionDate: String
}

class MessagesVC: UIViewController, URLSessionWebSocketDelegate, WebSocketDelegate {
    internal var name: String
    internal var image: UIImage
    internal var chatId: Int
    internal var userId: Int
    
    internal var messages: [MessageType] = []
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    private var webSocket: WebSocket?
    
    internal let messagesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    internal let sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = (.const(.height) - 2 * .const(.halfSpacing)) * 0.5
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
        view.layer.cornerRadius = .const(.height) * 0.5
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
        connectWebSocket()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        webSocket?.disconnect()
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
    deinit { NotificationCenter.default.removeObserver(self) }
    
    // MARK: - WebSockets
    func didReceiveData(data: Data) {
        print(data.prettyPrintedJSONString as Any)
    }
    
    func didReceiveData(data: String) {
        let messageData = Data(data.utf8)
        let decoder = JSONDecoder()
        do {
            let message = try decoder.decode(MessageRow.self, from: messageData)
            configureMessages(with: message, withAnimation: true)
        } catch { print("Can't receive message") }
    }
    
    private func connectWebSocket() {
        guard let url = URLService.shared.createWebSocketURL(chatId: chatId) else { return }
        webSocket = WebSocket(url: url, delegate: self)
        webSocket?.connect()
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
            sendMessageView.heightAnchor.constraint(equalToConstant: .const(.height)),
            sendMessageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            sendMessageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .const(.spacing)),
            sendMessageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.const(.spacing)),
            
            sendButton.trailingAnchor.constraint(equalTo: sendMessageView.trailingAnchor, constant: -.const(.halfSpacing)),
            sendButton.centerYAnchor.constraint(equalTo: sendMessageView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: .const(.height) - 2 * .const(.halfSpacing)),
            sendButton.heightAnchor.constraint(equalToConstant: .const(.height) - 2 * .const(.halfSpacing)),
            
            messageTextField.leadingAnchor.constraint(equalTo: sendMessageView.leadingAnchor, constant: .const(.height) * 0.5),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -.const(.halfSpacing)),
            messageTextField.topAnchor.constraint(equalTo: sendMessageView.topAnchor, constant: .const(.halfSpacing)),
            messageTextField.bottomAnchor.constraint(equalTo: sendMessageView.bottomAnchor, constant: -.const(.halfSpacing))
        ])
        
        contentView.addSubview(messagesTableView)
        
        NSLayoutConstraint.activate([
            messagesTableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            messagesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            messagesTableView.bottomAnchor.constraint(equalTo: sendMessageView.topAnchor, constant: -.const(.spacing)),
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
            self.scrollView.setContentOffset(CGPoint(x: 0, y: endFrame.height + .const(.spacing)), animated: false)
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
                                            time: messageData.createdAt.toTime(),
                                            side: .right,
                                            roundType: .end)
                
                webSocket?.send(message: newMessage)
                
                messageTextField.text = ""
                sendButton.tintColor = .inactive
            } catch {
                showSnackBar(text: error.localizedDescription, image: .systemImage(.warning, color: .label), on: self)
            }
        }
    }
    
    func configureMessages(with newMessage: MessageRow, withAnimation: Bool) {
        let messageTypeMessage: MessageType = .message(newMessage)
        
        let sectionRow = SectionRow(sectionDate: newMessage.date.toSectionDate())
        let messageTypeSection: MessageType = .section(sectionRow)
        var countOfNewMessages = 0
        
        if messages.isEmpty {
            messages.append(messageTypeSection)
            messages.append(messageTypeMessage)
            countOfNewMessages = 2
        } else {
            switch messages.last {
            case let .message(messageRow):
                if messageRow.date.toDateWithoutTime() != newMessage.date.toDateWithoutTime() {
                    messages.append(messageTypeSection)
                    messages.append(messageTypeMessage)
                    countOfNewMessages = 2
                } else {
                    messages.append(messageTypeMessage)
                    countOfNewMessages = 1
                }
            default:
                countOfNewMessages = 0
            }
        }
        
        // MARK: Set RoundType of messages
        let lastIndex = messages.count - 1
        if countOfNewMessages == 2 {
            setMessageRoundType(message: &messages[lastIndex], roundType: .startEnd)
        } else {
            guard let currentMessageRow = getMessageRow(message: messages[lastIndex]),
                  let previousMessageRow = getMessageRow(message: messages[lastIndex - 1]) else {
                return
            }
            
            if currentMessageRow.side != previousMessageRow.side {
                setMessageRoundType(message: &messages[lastIndex], roundType: .startEnd)
            } else {
                switch previousMessageRow.roundType {
                case .startEnd:
                    let timeDelay = currentMessageRow.date - previousMessageRow.date
                    if timeDelay > 120 {
                        setMessageRoundType(message: &messages[lastIndex], roundType: .startEnd)
                    } else {
                        setMessageRoundType(message: &messages[lastIndex], roundType: .end)
                        setMessageRoundType(message: &messages[lastIndex - 1], roundType: .start)
                    }
                case .end:
                    var startIndex = lastIndex - 2
                    while getMessageRow(message: messages[startIndex])?.roundType != .start {
                        startIndex -= 1
                    }
                    guard let startMessageRow = getMessageRow(message: messages[startIndex]) else { return }
                    let timeDelay = currentMessageRow.date - startMessageRow.date
                    if timeDelay > 120 {
                        setMessageRoundType(message: &messages[lastIndex], roundType: .startEnd)
                    } else {
                        setMessageRoundType(message: &messages[lastIndex], roundType: .end)
                        setMessageRoundType(message: &messages[lastIndex - 1], roundType: .between)
                    }
                default:
                    return
                }
            }
        }
        
        if withAnimation {
            messagesTableView.scrollToBottom()
            
            // Inserting a rows at the end
            var indexPathsAdded: [IndexPath] = []
            for rowNumber in 1...countOfNewMessages {
                indexPathsAdded.append(IndexPath(row: messages.count - rowNumber, section: 0))
            }
            
            var indexPathsUpdated: [IndexPath] = []
            if !messages.isEmpty {
                for rowNumber in 1...countOfNewMessages + 1 {
                    indexPathsUpdated.append(IndexPath(row: messages.count - rowNumber, section: 0))
                }
            } else {
                indexPathsUpdated = [IndexPath(row: 0, section: 0)]
            }
            
            DispatchQueue.main.async {
                self.messagesTableView.performBatchUpdates({
                    self.messagesTableView.insertRows(at: indexPathsAdded, with: .fade)
                    self.messagesTableView.reloadRows(at: indexPathsUpdated, with: .none)
                }, completion: nil)
            }
        }
        
        func getMessageRow(message: MessageType) -> MessageRow? {
            switch message {
            case let .message(messageRow):
                return messageRow
            default:
                return nil
            }
        }
        
        func setMessageRoundType(message: inout MessageType, roundType: RoundType) {
            guard let messageRow = getMessageRow(message: message) else { return }
            let newMessage = MessageType.message(MessageRow(authorId: messageRow.authorId,
                                                            message: messageRow.message,
                                                            date: messageRow.date,
                                                            time: messageRow.time,
                                                            side: messageRow.side,
                                                            roundType: roundType))
            message = newMessage
        }
    }
}
