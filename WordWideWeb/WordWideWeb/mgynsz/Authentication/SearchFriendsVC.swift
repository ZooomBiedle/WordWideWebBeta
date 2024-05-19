//
//  SearchFriendsVC.swift
//  WordWideWeb
//
//  Created by David Jang on 5/17/24.
//

import UIKit
import FirebaseFirestore
import SnapKit
import FirebaseAuth

class SearchFriendsVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    private var friends: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSearchBar()
        setupTableView()
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
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search friends..."
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(48)
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendCell.self, forCellReuseIdentifier: FriendCell.identifier)
        tableView.tableFooterView = UIView()
    }
    
    private func searchFriends(with query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return }
        
        Firestore.firestore().collection("users")
            .whereField("displayName", isGreaterThanOrEqualTo: trimmedQuery)
            .whereField("displayName", isLessThanOrEqualTo: trimmedQuery + "\u{f8ff}")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching friends: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else {
                    print("No friends found")
                    return
                }
                self.friends = documents.compactMap { try? $0.data(as: User.self) }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            friends = []
            tableView.reloadData()
            return
        }
        searchFriends(with: searchText)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier, for: indexPath) as! FriendCell
        let friend = friends[indexPath.row]
        cell.configure(with: friend)
        return cell
    }
}

