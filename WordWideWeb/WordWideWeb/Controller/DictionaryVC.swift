//
//  DictionaryViewController.swift
//  WordWideWeb
//
//  Created by 박준영 on 5/17/24.
//

import UIKit
import SnapKit

class DictionaryVC: UIViewController {
    
    private let logo: UILabel = {
       let label = UILabel()
        label.text = "Add Word"
        label.font = UIFont.pretendard(size: 20, weight: .semibold)
        return label
    }()
    private var searchBar = SearchBarWhite(frame: .zero, placeholder: "찾는 단어를 입력하세요", cornerRadius: 10)
    private lazy var tableview = UITableView()
    
    private var receivedItem: [Item] = [] {
        didSet {
            tableview.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setConstraints()
    }
    
    func configureUI() {
        self.view.backgroundColor = UIColor(named: "bgColor")
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.searchBar.delegate = self
        searchBar.backgroundColor = .white
        searchBar.searchTextField.backgroundColor = .white
        searchBar.layer.borderColor = UIColor.white.cgColor
        
        self.tableview.dataSource = self
        tableview.register(DictionaryTableViewCell.self, forCellReuseIdentifier: DictionaryTableViewCell.identifier)
        self.tableview.backgroundColor = UIColor(named: "bgColor")
    }
   
    func setConstraints() {
        [logo, searchBar, tableview].forEach {
            self.view.addSubview($0)
        }
        
        logo.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
            
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(logo.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        tableview.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}


extension DictionaryVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        print("Search query: \(keyword)")
        NetworkManager.shared.fetchAPI(query: keyword) { [weak self] items in
            guard let self else { return }
            print("Items received: \(items.count)")
            self.receivedItem = items
        }
    }
}


extension DictionaryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receivedItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryTableViewCell.identifier, for: indexPath) as! DictionaryTableViewCell
        
        let index = receivedItem[indexPath.row]
        cell.wordLabel.text = index.word
        cell.setStackView(item: index)

        return cell
    }
}
