//
//  WebSocket.swift
//  Messenger
//
//  Created by e1ernal on 30.03.2024.
//

import Foundation

protocol WebSocketDelegate: AnyObject {
    func didReceiveData(data: Data)
    func didReceiveData(data: String)
}

class WebSocket: NSObject, URLSessionDelegate, URLSessionWebSocketDelegate {
    weak var delegate: WebSocketDelegate?
    private var webSocket: URLSessionWebSocketTask?
    private var url: URL
    private var isConnected: Bool = false

    init(url: URL, delegate: WebSocketDelegate) {
        self.url = url
        self.delegate = delegate
        super.init()
    }

    func connect() {
        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: OperationQueue())
        
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
    }

    func send(data: Data) {
        webSocket?.send(.data(data)) { error in
            if let error { print("Send error: \(error)") }
        }
    }
    
    func send(message: MessageRow) {
        let encoder = JSONEncoder()
        do { 
            let jsonData = try encoder.encode(message)
            if let jsonString = String(data: jsonData,
                                       encoding: .utf8) {
                ping()
                webSocket?.send(.string(jsonString)) { error in
                    if let error { print("Send error: \(error)") }
                }
            }
        } catch { print("Send error while encoding") }
    }

    private func receive() {
        if isConnected {
            webSocket?.receive { [weak self] result in
                switch result {
                case let .success(message):
                    switch message {
                    case .data(let data):
                        self?.delegate?.didReceiveData(data: data)
                    case .string(let string):
                        self?.delegate?.didReceiveData(data: string)
                    @unknown default:
                        print("Receive error: unknown data")
                    }
                case let .failure(error):
                    if self?.isConnected == true {
                        print("Receive error: \(error)")
                    }
                }
                self?.receive()
            }
        }
    }

    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?) {
        print("WebSocket: Connected")
        isConnected = true
        receive()
    }
    
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        isConnected = false
        print("WebSocket: Disconnected")
    }

    private func ping() {
        webSocket?.sendPing { error in
            if let error {
                print("Ping error: \(error)")
                self.isConnected = false
            }
        }
    }
    
    func disconnect() {
        isConnected = false
        webSocket?.cancel(with: .goingAway, reason: nil)
    }
}
