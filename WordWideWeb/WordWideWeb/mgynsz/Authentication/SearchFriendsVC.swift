//
//  SearchFriendsVC.swift
//  WordWideWeb
//
//  Created by David Jang on 5/17/24.
//

import UIKit
import FirebaseAuth
import SnapKit

class SearchFriendsVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    private var friends: [User] = []
    private var searchTask: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSearchBar()
        setupTableView()
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
    
    private func searchFriends(with query: String) async {
        do {
            let users: [User]
            if query.contains("@") {
                users = try await FirestoreManager.shared.searchUserByEmail(query: query)
            } else {
                users = try await FirestoreManager.shared.searchUserByName(query: query)
            }
            self.friends = users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error searching friends: \(error.localizedDescription)")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()
        
        let task = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            guard !searchText.isEmpty else {
                self.friends = []
                self.tableView.reloadData()
                return
            }
            Task {
                await self.searchFriends(with: searchText)
            }
        }
        
        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
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
