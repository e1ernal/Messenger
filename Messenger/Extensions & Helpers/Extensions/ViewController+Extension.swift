//
//  ViewController+Extensions.swift
//  Messenger
//
//  Created by e1ernal on 26.12.2023.
//

import UIKit

enum Navigation {
    case next(UIViewController, Style)
    case back
    case root(UIViewController)
    case rootNavigation(UIViewController)
    
    enum Style {
        case fullScreen
        case pageSheet([UISheetPresentationController.Detent])
    }
}

enum Row {
    case emptyRow
    case textFieldRow(placeholder: String, text: String)
    case doubleLabelRow(left: String, right: String)
    case regularRow(text: String)
    case imageDoubleLabelRow(image: String, top: String, bottom: String)
    case imageRow(image: String)
    case imageWithButtonRow(image: String, buttonText: String)
    case chatRow(image: String, name: String, message: String, date: String)
    
    func getValue() -> [String: String] {
        switch self {
        case .emptyRow:
            return [:]
        case let .textFieldRow(placeholder, text):
            return ["placeholder": placeholder, "text": text]
        case let .doubleLabelRow(left, right):
            return ["left": left, "right": right]
        case let .regularRow(text):
            return ["text": text]
        case let .imageDoubleLabelRow(image, top, bottom):
            return ["image": image, "top": top, "bottom": bottom]
        case let .imageRow(image):
            return ["image": image]
        case let .imageWithButtonRow(image, buttonText):
            return ["image": image, "buttonText": buttonText]
        case let .chatRow(image, name, message, date):
            return ["image": image, "name": name, "message": message, "date": date]
        }
    }
}

struct Section {
    var header: String = ""
    var footer: String = ""
    var rows: [Row] = []
}

extension UIViewController {
    // MARK: - Navigation Controller actions
    
    /// Navigation through controllers with different styles
    /// - Parameter navigation: Show next view controller or go back
    func navigate(_ navigation: Navigation) {
        switch navigation {
        case .back:
            navigationController?.popViewController(animated: true)
        case let .next(nextVC, style):
            switch style {
            case .fullScreen:
                navigationController?.pushViewController(nextVC, animated: true)
            case .pageSheet(let detents):
                let nav = UINavigationController(rootViewController: nextVC)
                nav.modalPresentationStyle = .pageSheet
                
                if let sheet = nav.sheetPresentationController {
                    sheet.detents = detents
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                }
                navigationController?.present(nav, animated: true, completion: nil)
            }
        case .root(let nextVC):
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    sceneDelegate.changeRootViewController(with: nextVC)
                }
            }
        case .rootNavigation(let nextVC):
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    sceneDelegate.changeRootViewController(with: UINavigationController(rootViewController: nextVC))
                }
            }
        }
    }
    
    // MARK: - Keyboard actions
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Setup basic View Controller
    /// - Parameters:
    ///     - title: Title to View Controller
    ///     - backButton: Show back button as navigationItem
    func configureVC(title: String?, backButton: Bool) {
        self.title = title
        view.backgroundColor = .color(.background)
        navigationItem.setHidesBackButton(!backButton, animated: true)
        hideKeyboardWhenTappedAround()
    }
    
    func numberFormatter(_ number: String) -> String {
        let mask = "+X (XXX) XXX-XXXX"
        let number = number.replacingOccurrences(of: "[^0-9]",
                                                 with: "",
                                                 options: .regularExpression)
        var result: String = ""
        var index = number.startIndex
        for character in mask where index < number.endIndex {
            if character == "X" {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(character)
            }
        }
        return result
    }
    
    func showSnackBar(text: String, image: UIImage, on vc: UIViewController) {
        print("[Snack Bar information] \n \(text)")
        
        let snackBarViewModel = SnackBarViewModel(text: text, image: image)
        let vcWidth = vc.view.frame.size.width
        let vcHeight = vc.view.frame.size.height
        
        let snackBarWidth = vcWidth * 0.9
        let snackBarHeight: CGFloat = .constant(.height)
        
        let frame = CGRect(x: 0,
                           y: 0,
                           width: snackBarWidth,
                           height: snackBarHeight)
        let snackBar = SnackBarView(viewModel: snackBarViewModel, frame: frame)
        
        snackBar.frame = CGRect(x: (vcWidth - snackBarWidth) / 2,
                                y: vcHeight,
                                width: snackBarWidth,
                                height: snackBarHeight)
        
        var tabBarControllerHeight: CGFloat = 0
        if let tabBar = vc.tabBarController?.tabBar {
            tabBarControllerHeight = tabBar.isHidden ? 0 : tabBar.frame.height
        }
        
        if let tableViewController = vc as? UITableViewController {
            tableViewController.tableView.superview?.addSubview(snackBar)
        } else {
            vc.view.addSubview(snackBar)
        }
        
        var snackBarY: CGFloat
        if KeyboardStateListener.shared.isVisible {
            snackBarY = vcHeight - snackBarHeight - .constant(.spacing) - KeyboardStateListener.shared.keyboardHeight
        } else {
            snackBarY = vcHeight - snackBarHeight * 2 - tabBarControllerHeight
        }
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: {
            snackBar.frame = CGRect(x: (vcWidth - snackBarWidth) / 2,
                                    y: snackBarY,
                                    width: snackBarWidth,
                                    height: snackBarHeight)
        }, completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    UIView.animate(withDuration: 0.5,
                                   delay: 0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 1,
                                   options: .curveEaseInOut,
                                   animations: {
                        snackBar.frame = CGRect(x: (vcWidth - snackBarWidth) / 2,
                                                y: vcHeight,
                                                width: snackBarWidth,
                                                height: snackBarHeight)
                    }, completion: { finished in
                        if finished {
                            snackBar.removeFromSuperview()
                        }
                    })
                }
            }
        })
    }
    
    func loadingAlert(isPresenting: Bool) {
        if isPresenting {
            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.medium
            loadingIndicator.startAnimating()

            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
        } else {
            dismiss(animated: false, completion: nil)
        }
    }
}
