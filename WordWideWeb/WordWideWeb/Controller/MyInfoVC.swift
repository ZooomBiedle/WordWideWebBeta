//
//  MyInfoViewController.swift
//  WordWideWeb
//
//  Created by 박준영 on 5/16/24.
//

import UIKit
import FirebaseAuth
import SnapKit
import SDWebImage
import Combine
import FirebaseStorage
import FirebaseFirestore

class MyInfoVC: UIViewController {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(size: 18, weight: .regular)
        return label
    }()
    
    private let blockCountLabel: UILabel = {
        let label = UILabel()
        label.text = "block 1,234"
        label.font = UIFont.pretendard(size: 14, weight: .light)
        label.textColor = .pointGreen
        return label
    }()
    
    private let instagramIcon: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "instagramlogo"), for: .normal)
        button.tintColor = .black
        button.isHidden = true
        return button
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "mainBtn")
        button.setTitle("Profile Settings", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "pointRed")
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 160, height: 160)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    private let addWordBookButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .pointGreen
        button.backgroundColor = UIColor(named: "mainBtn")
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 10
        return button
    }()
    
    private let viewModel = ProfileViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var buttons: [UIButton] = []
    private var segmentIcons = ["person", "person.3"]
    private let indicatorView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bgColor")
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupViews()
        setupCollectionView()
        bindViewModel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDidUpdate), name: .userProfileUpdated, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .userProfileUpdated, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchUserInfo()
    }
    
    private func bindViewModel() {
        viewModel.$displayName
            .receive(on: DispatchQueue.main)
            .sink { [weak self] displayName in
                self?.nicknameLabel.text = displayName
            }
            .store(in: &cancellables)
        
        viewModel.$photoURL
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url in
                guard let self = self else { return }
                if let url = url {
                    self.profileImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.crop.circle"))
                } else {
                    self.profileImageView.image = UIImage(systemName: "person.crop.circle")
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupViews() {
        view.addSubview(profileImageView)
        view.addSubview(nicknameLabel)
        view.addSubview(blockCountLabel)
        view.addSubview(instagramIcon)
        view.addSubview(profileButton)
        view.addSubview(logoutButton)
        view.addSubview(collectionView)
        view.addSubview(addWordBookButton)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.width.height.equalTo(70)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(24)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        blockCountLabel.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.bottom).offset(-4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        instagramIcon.snp.makeConstraints { make in
            make.bottom.equalTo(logoutButton.snp.top).offset(-10)
            make.trailing.equalTo(view).offset(-20)
            make.width.height.equalTo(30)
        }
        
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(20)
            make.height.equalTo(40)
            make.trailing.equalTo(view.snp.centerX).offset(-10) // 너비를 유동적으로 설정
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.centerX).offset(10) // 너비를 유동적으로 설정
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
            make.width.equalTo(profileButton.snp.width)
        }
        
        setupSegmentControl()
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(indicatorView.snp.bottom).offset(16)
            make.left.right.bottom.equalTo(view).inset(20)
        }
        
        addWordBookButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.trailing.equalTo(view).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        addWordBookButton.addTarget(self, action: #selector(addWordBookButtonTapped), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
    }
    
    private func setupSegmentControl() {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.left.right.equalTo(view).inset(20)
            make.height.equalTo(32)
        }
        
        segmentIcons.forEach { iconName in
            let button = UIButton()
            let image = UIImage(systemName: iconName)
            button.setImage(image, for: .normal)
            button.tintColor = .black // 아이콘 색상 설정
            button.addTarget(self, action: #selector(segmentButtonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        buttons.first?.isSelected = true
        setupIndicatorView()
    }
    
    private func setupIndicatorView() {
        guard let firstButton = buttons.first else { return }
        view.addSubview(indicatorView)
        indicatorView.backgroundColor = .black
        
        indicatorView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.top.equalTo(firstButton.snp.bottom)
            make.width.equalTo(firstButton.snp.width)
            make.centerX.equalTo(firstButton.snp.centerX)
        }
    }
    
    @objc private func userDidUpdate() {
        viewModel.fetchUserInfo()
    }
    
    @objc private func profileButtonTapped() {
        let profileVC = ProfileVC()
        profileVC.modalPresentationStyle = .formSheet
        present(profileVC, animated: true, completion: nil)
    }
    
    @objc private func segmentButtonTapped(_ sender: UIButton) {
        for button in buttons {
            button.isSelected = (button == sender)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.indicatorView.snp.remakeConstraints { make in
                make.height.equalTo(2)
                make.top.equalTo(sender.snp.bottom)
                make.width.equalTo(sender.snp.width)
                make.centerX.equalTo(sender.snp.centerX)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func addWordBookButtonTapped() {
        // + 버튼을 눌렀을 때 실행할 코드
        print("add wordbook tapped")
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
  
    @objc private func logoutTapped() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.isLoggedIn = false
            UserDefaults.standard.isAutoLoginEnabled = false
            NotificationCenter.default.post(name: .userDidLogout, object: nil)
            guard let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate else { return }
            sceneDelegate.setRootViewController()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

// MARK: 컬렉션뷰

extension MyInfoVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .lightGray
        cell.layer.cornerRadius = 10
        return cell
    }
}
