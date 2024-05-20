//
//  InvitingVC.swift
//  WordWideWeb
//
//  Created by 박준영 on 5/17/24.
//

import UIKit

class InvitingVC: UIViewController {
    
    private let logo: UILabel = {
       let label = UILabel()
        label.text = "Notify"
        label.font = UIFont.pretendard(size: 20, weight: .semibold)
        return label
    }()
    private let tableview = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func configureUI() {
        self.view.backgroundColor = UIColor(named: "bgColor")
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.tableview.dataSource = self
        tableview.register(DictionaryTableViewCell.self, forCellReuseIdentifier: DictionaryTableViewCell.identifier)
        self.tableview.backgroundColor = UIColor(named: "bgColor")
    }
    
    func setConstraints() {
        logo.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        tableview.snp.makeConstraints { make in
            make.top.equalTo(logo).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}


extension InvitingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
