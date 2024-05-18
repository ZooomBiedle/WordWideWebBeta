//
//  SearchFriendsVC.swift
//  WordWideWeb
//
//  Created by David Jang on 5/17/24.
//

//import UIKit
//import FirebaseFirestore
//import SnapKit
//import FirebaseAuth
//
//class SearchFriendsVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
//    
//    private let logoutButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Log Out", for: .normal)
//        button.setTitleColor(.red, for: .normal)
//        return button
//    }()
//    
//    private let searchBar = UISearchBar()
//    private let tableView = UITableView()
//    
//    private var friends: [User] = []
//    private var filteredFriends: [User] = []
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupNavigationBar()
//        setupSearchBar()
//        setupTableView()
//        fetchFriends()
//    }
//    
//        @objc private func logoutTapped() {
//            do {
//                try Auth.auth().signOut()
//                UserDefaults.standard.isLoggedIn = false
//                UserDefaults.standard.isAutoLoginEnabled = false
//                NotificationCenter.default.post(name: .userDidLogout, object: nil)
//                guard let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate else { return }
//                sceneDelegate.setRootViewController()
//            } catch {
//                print("Error signing out: \(error.localizedDescription)")
//            }
//        }
//    
//    private func setupNavigationBar() {
//        title = "친구 검색"
//        navigationController?.navigationBar.prefersLargeTitles = false
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
//        navigationController?.navigationBar.tintColor = .black
//    }
//    
//    private func setupSearchBar() {
//        searchBar.delegate = self
//        searchBar.placeholder = "함께할 친구를 찾아보세요"
//        navigationItem.titleView = searchBar
//    }
//    
//    private func setupTableView() {
//        view.addSubview(logoutButton)
//        view.addSubview(tableView)
//        view.addSubview(searchBar)
//
//        logoutButton.snp.makeConstraints { make in
//            make.centerX.equalTo(view)
//            make.top.equalTo(view.snp.bottom).offset(20)
//        }
//        
//        searchBar.snp.makeConstraints { make in
//            make.top.equalTo(logoutButton.snp.bottom).offset(20)
//            make.left.equalTo(view).offset(20)
//            make.right.equalTo(view).offset(-20)
//            make.height.equalTo(48)
//        }
//        
//        tableView.snp.makeConstraints { make in
//            make.top.equalTo(searchBar.snp.bottom).offset(20)
//            make.left.equalTo(view).offset(20)
//            make.right.equalTo(view).offset(-20)
//            make.height.equalTo(48)
//        }
//        
//
//        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(FriendCell.self, forCellReuseIdentifier: FriendCell.identifier)
//        tableView.tableFooterView = UIView()
//
//    }
//    
//    private func fetchFriends() {
//        Firestore.firestore().collection("users").getDocuments { snapshot, error in
//            if let error = error {
//                print("Error fetching friends: \(error.localizedDescription)")
//                return
//            }
//            guard let documents = snapshot?.documents else {
//                print("No friends found")
//                return
//            }
//            self.friends = documents.compactMap { try? $0.data(as: User.self) }
//            self.filteredFriends = self.friends
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
//    
//    // UISearchBarDelegate
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        filteredFriends = searchText.isEmpty ? friends : friends.filter { $0.displayName?.contains(searchText) == true }
//        tableView.reloadData()
//    }
//    
//    // UITableViewDelegate, UITableViewDataSource
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filteredFriends.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier, for: indexPath) as! FriendCell
//        let friend = filteredFriends[indexPath.row]
//        cell.configure(with: friend)
//        return cell
//    }
//    
//    @objc private func backButtonTapped() {
//        navigationController?.popViewController(animated: true)
//    }
//}

