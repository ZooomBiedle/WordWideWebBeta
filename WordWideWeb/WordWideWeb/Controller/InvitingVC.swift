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
    
    //private var InvitationList = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setConstraints()
    }
    
    func configureUI() {
        self.view.backgroundColor = UIColor(named: "bgColor")
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        tableview.register(InvitingTableViewCell.self, forCellReuseIdentifier: InvitingTableViewCell.idenifier)
        self.tableview.backgroundColor = UIColor(named: "bgColor")
        self.tableview.dataSource = self
    }
    
    func setConstraints() {
        [logo, tableview].forEach {
            self.view.addSubview($0)
        }
        
        logo.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        tableview.snp.makeConstraints { make in
            make.top.equalTo(logo.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}


extension InvitingVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1   // InvitationList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Today"   // 알림 날짜 적기
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InvitingTableViewCell.idenifier, for: indexPath) as! InvitingTableViewCell
        
        cell.section.setUI()
        
        return cell
    }
    
    
}
