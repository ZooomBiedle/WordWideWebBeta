//
//  DictionaryViewController.swift
//  WordWideWeb
//
//  Created by 박준영 on 5/17/24.
//

import UIKit
import SnapKit

class DictionaryVC: UIViewController {
    
    let searchBar = SearchBarWhite()
    private lazy var tableview = UITableView()
    
    private var receivedItems: [Item] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setConstraints()
    }
    
    func configureUI() {
        self.view.backgroundColor = UIColor(named: "bgColor")
        
        self.searchBar.delegate = self
        searchBar.frame = CGRect()
        self.tableview.dataSource = self
        tableview.register(DictionaryTableViewCell.self, forCellReuseIdentifier: DictionaryTableViewCell.identifier)
        self.tableview.backgroundColor = UIColor(named: "bgColor")
        
        NetworkManager.shared.fetchAPI(query: "나무") { [weak self] item in
            guard let self = self else { return }
            self.receivedItems = item.compactMap{ $0 }
            self.tableview.reloadData()
            print(receivedItems)
        }

    }
   
    func setConstraints() {
        [searchBar, tableview].forEach {
            self.view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        tableview.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
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
        NetworkManager.shared.fetchAPI(query: keyword) { item in
            self.receivedItems = item
        }
    }
}


extension DictionaryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receivedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryTableViewCell.identifier, for: indexPath) as! DictionaryTableViewCell
        
        let items = self.receivedItems[indexPath.row]
        let senceElements = items.sense[indexPath.row]
        cell.wordLabel.text = items.word
        cell.EngLabel.text = "\(senceElements.senseOrder)." + " \(items.pos)" + "  \(senceElements.transWord)"
        
        return cell
    }
    
    
}
