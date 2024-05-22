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
    
    private var invitationList: [[InvitationData]] = [
        [InvitationData(id: "1", ownerId: "jiyeon", photoURL: nil, title: "영어단어장100", dueDate: "2024.05.24", createdAt: 20240520, words: ["world", "tree", "apple"]),
        InvitationData(id: "2", ownerId: "nayeon", photoURL: nil, title: "개발자필수단어장", dueDate: "2024.05.23", createdAt: 20240520, words: ["api", "computer", "keyboard", "macbook", "framework"])],
        [InvitationData(id: "3", ownerId: "jinyeong", photoURL: nil, title: "호텔필수단어장", dueDate: "2024.05.23", createdAt: 20240518, words: ["kindness", "frontdesk", "owner", "amenity", "buffet"])]
    ]
    
    var openedIndex: IndexPath?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setConstraints()
    }
    
    func configureUI() {
        self.view.backgroundColor = UIColor(named: "bgColor")
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        tableview.register(DefaultTableViewCell.self, forCellReuseIdentifier: DefaultTableViewCell.identifier)
        tableview.register(ExpandableTableViewCell.self, forCellReuseIdentifier: ExpandableTableViewCell.identfier)
        self.tableview.backgroundColor = UIColor(named: "bgColor")
        self.tableview.dataSource = self
        self.tableview.delegate = self
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
    
//    private func map(_ users: [User], _ wordbooks: [Wordbook], _ words: [Word]) -> [InvitationData] {
//        items.reduce(into: [invitationList]()) { acc, wordbook in
//            let models = wordbook.map {
//                InvitationData(id: wordbook.id, ownerId: wordbook.ownerId, title: wordbook.title, dueDate: wordbook.dueDate, createdAt: wordbook.createdAt)
//            }
//            acc.append(models)
//        }
//        
//        var invitationDatas: [InvitationData] = []
//        
//        for user in users {
//            let filtered = wordbooks.filter {
//                $0.ownerId == user.uid
//            }
//            for wordbook in filtered {
//                for w in wordbook.wordIDList {
//                    let filteredWords = words.filter {
//                        $0.id == w
//                    }
//                    for f in filteredWords {
//                        InvitationData(id: <#T##String#>, ownerId: user.uid, photoURL: <#T##String?#>, title: <#T##String#>, dueDate: <#T##String#>, createdAt: <#T##String#>, words: <#T##[String]#>)
//                        invitationDatas.append(<#T##newElement: InvitationData##InvitationData#>)
//                    }
//                }
//            }
//        }
//        return invitationDatas
//    }
    
}
    
    
extension InvitingVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return invitationList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // 각 섹션의 첫 번째 InvitationData의 createdAt 값을 헤더로 사용
        let firstInvitationInSection = invitationList[section].first
        let createdAtString = String(firstInvitationInSection?.createdAt ?? 0)

        return createdAtString
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = invitationList[section].count
        
        // 섹션 내 모든 InvitationData의 open 상태를 확인
        for invitation in invitationList[section] {
            if invitation.open {
                rowCount += 1 // open 상태인 InvitationData가 있다면 확장된 셀을 추가
            }
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 90
        } else {
            return 90
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = invitationList[indexPath.section][indexPath.row]
        
        if index.open {
            let cell = tableview.dequeueReusableCell(withIdentifier: DefaultTableViewCell.identifier, for: indexPath) as! DefaultTableViewCell
            
            cell.defaultView.bind(imageData: Data(), title: index.title, date: index.dueDate)
            
            return cell
        } else {
            let cell = tableview.dequeueReusableCell(withIdentifier: ExpandableTableViewCell.identfier, for: indexPath) as! ExpandableTableViewCell
            

            cell.bindExpandedView(words: index.words)
            cell.rejectButtonAction = { [weak self] in
                self?.invitationList.remove(at: indexPath.row)
                self?.tableview.deleteRows(at: [indexPath], with: .automatic)
            }
            cell.acceptButtonAction = { [weak self] in
                print("단어장 초대 수락")
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableview.cellForRow(at: indexPath) as? DefaultTableViewCell else {return}
        guard let index = tableview.indexPath(for: cell) else { return }
       
        if index.row == indexPath.row {
            if index.row == 0 {
                if invitationList[indexPath.section][indexPath.row].open {
                    invitationList[indexPath.section][index.row].open.toggle()
                    let section = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(section, with: .fade)
                } else {
                    invitationList[indexPath.section][index.row].open.toggle()
                    let section = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(section, with: .fade)
                }
            }
        }
    }
    
}

