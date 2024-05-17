//
//  ViewController.swift
//  WorldWordWeb
//
//  Created by 신지연 on 2024/05/14.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    private var friends: [User] = []
    private var filteredFriends: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupSearchBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        title = "친구 검색"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "함께할 친구를 찾아보세요"
        searchBar.sizeToFit()
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendCell.self, forCellReuseIdentifier: FriendCell.identifier)
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredFriends = searchText.isEmpty ? friends : friends.filter { $0.displayName?.contains(searchText) ?? false }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchUsers(byName: query)
    }
    
    private func searchUsers(byName name: String) {
        Task {
            do {
                let users = try await FirestoreManager.shared.searchUserByName(name: name)
                self.friends = users
                self.filteredFriends = users
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                // 콘솔에 데이터를 출력합니다.
                for friend in self.friends {
                    print("Friend: \(friend.displayName ?? "Unknown")")
                }
            } catch {
                print("Error fetching friends: \(error.localizedDescription)")
            }
        }
    }
    
    // UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier, for: indexPath) as! FriendCell
        let friend = filteredFriends[indexPath.row]
        cell.configure(with: friend)
        return cell
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}



//class ViewController: UIViewController {
//    
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        return label
//    }()
//    
//    private let logoutButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Log Out", for: .normal)
//        button.setTitleColor(.red, for: .normal)
//        return button
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.white
//        setupViews()
//    }
//    
//    private func setupViews() {
//        titleLabel.text = "WWW"
//        
//        view.addSubview(titleLabel)
//        view.addSubview(logoutButton)
//        
//        titleLabel.snp.makeConstraints { make in
//            make.centerX.equalTo(view)
//            make.centerY.equalTo(view)
//        }
//        
//        logoutButton.snp.makeConstraints { make in
//            make.centerX.equalTo(view)
//            make.top.equalTo(titleLabel.snp.bottom).offset(20)
//        }
//        
//        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
//    }
//    
//    @objc private func logoutTapped() {
//        do {
//            try Auth.auth().signOut()
//            UserDefaults.standard.isLoggedIn = false
//            UserDefaults.standard.isAutoLoginEnabled = false
//            NotificationCenter.default.post(name: .userDidLogout, object: nil)
//            guard let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate else { return }
//            sceneDelegate.setRootViewController()
//        } catch {
//            print("Error signing out: \(error.localizedDescription)")
//        }
//    }
//}
