//
//  WelcomeVC.swift
//  Messenger
//
//  Created by e1ernal on 02.01.2024.
//

import UIKit

class WelcomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Messenger"
        label.font = Font.title.font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let appFeaturesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.contentInsetAdjustmentBehavior = .never
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.register(CustomCollectionViewCell.self,
                            forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(changePage), for: UIControl.Event.valueChanged)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var startMessagingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start Messaging", for: .normal)
        button.titleLabel?.font = Font.button.font
        button.backgroundColor = Color.active.color
        button.layer.cornerRadius = Constraint.height.rawValue / 5
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var uiStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constraint.spacing.rawValue
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        hideKeyboardWhenTappedAround()
    }
    
    private func makeUI() {
        view.backgroundColor = Color.background.color
        navigationItem.setHidesBackButton(true, animated: true)
        
        appFeaturesCollection.delegate = self
        appFeaturesCollection.dataSource = self
        
        pageControl.numberOfPages = features.count
        
        view.addSubview(appNameLabel)
        view.addSubview(appFeaturesCollection)
        view.addSubview(startMessagingButton)
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            appFeaturesCollection.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            appFeaturesCollection.heightAnchor.constraint(equalToConstant: Constraint.doubleHeight.rawValue),
            appFeaturesCollection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appFeaturesCollection.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            appNameLabel.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appNameLabel.bottomAnchor.constraint(equalTo: appFeaturesCollection.topAnchor),
            
            pageControl.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: appFeaturesCollection.bottomAnchor),
            
            startMessagingButton.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            startMessagingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startMessagingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constraint.doubleHeight.rawValue),
            startMessagingButton.heightAnchor.constraint(equalToConstant: Constraint.height.rawValue)
        ])
    }
    
    // MARK: - UIPageControl Method
    /// Change CollectionView page by tapping on pageControl
    @objc
    func changePage() {
        let number = pageControl.currentPage
        appFeaturesCollection.selectItem(at: IndexPath(row: number,
                                                       section: 0),
                                         animated: true,
                                         scrollPosition: .centeredHorizontally)
    }
    
    // MARK: - Button Method
    /// Show Login/Sing-in ViewControllers
    @objc
    func continueButtonTapped() {
        showNextVC(nextVC: PhoneVC())
    }
    
    // MARK: - UICollectionView Methods
    private let features: [String] = [
        "Messenger is a messaging app with a focus on speed and security",
        "We support end-to-end encryption for messaging",
        "All Messenger chats are private amongst their participants",
        "The way of contacting people is to type their Messenger username into the search field"
    ]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        features.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier,
                                                            for: indexPath) as? CustomCollectionViewCell else {
            fatalError("Can't convert to CustomCollectionViewCell")
        }
        cell.setText(text: features[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width * 2 / 3, height: Constraint.doubleHeight.rawValue)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
}
