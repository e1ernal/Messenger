//
//  WelcomeVC.swift
//  Messenger
//
//  Created by e1ernal on 02.01.2024.
//

import UIKit

class WelcomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Messenger"
        label.font = .font(.title)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let featuresCollectionView: UICollectionView = {
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
    
    private lazy var featuresPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .color(.pageControlCurrent)
        pageControl.pageIndicatorTintColor = .color(.pageControlTint)
        pageControl.addTarget(self, action: #selector(changePage), for: UIControl.Event.valueChanged)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start Messaging", for: .normal)
        button.titleLabel?.font = .font(.button)
        button.backgroundColor = .color(.active)
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
        
        setupUI()
    }
    
    private func setupUI() {
        setupVC(title: "", backButton: false)
        
        featuresCollectionView.delegate = self
        featuresCollectionView.dataSource = self
        
        featuresPageControl.numberOfPages = features.count
        
        view.addSubview(nameLabel)
        view.addSubview(featuresCollectionView)
        view.addSubview(startButton)
        view.addSubview(featuresPageControl)
        
        NSLayoutConstraint.activate([
            featuresCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            featuresCollectionView.heightAnchor.constraint(equalToConstant: .constant(.doubleHeight)),
            featuresCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            featuresCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            nameLabel.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: featuresCollectionView.topAnchor),
            
            featuresPageControl.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            featuresPageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            featuresPageControl.topAnchor.constraint(equalTo: featuresCollectionView.bottomAnchor),
            
            startButton.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.constant(.doubleHeight)),
            startButton.heightAnchor.constraint(equalToConstant: .constant(.height))
        ])
    }
    
    // MARK: - UIPageControl Method
    /// Change CollectionView page by tapping on pageControl
    @objc
    func changePage() {
        let number = featuresPageControl.currentPage
        featuresCollectionView.selectItem(at: IndexPath(row: number, section: 0),
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
        return CGSize(width: self.view.frame.width * 2 / 3, height: .constant(.doubleHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        featuresPageControl.currentPage = indexPath.row
    }
}
