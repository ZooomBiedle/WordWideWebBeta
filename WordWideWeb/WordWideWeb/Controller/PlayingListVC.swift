//
//  PlayingListViewController.swift
//  WordWideWeb
//
//  Created by 박준영 on 5/16/24.
//

import UIKit
import Firebase

class PlayingListVC: UIViewController {
    
    // MARK: - properties
    private let playlistView = PlayingListView()
    private var selectedIndexPath: IndexPath?
    var wordBooks: [Wordbook] =  [
        Wordbook(
            id: UUID().uuidString,
            ownerId: UUID().uuidString,
            title: "Introduction to Swift",
            isPublic: true,
            dueDate: Timestamp(date: Date().addingTimeInterval(604800)), // 1 week from now
            createdAt: Timestamp(date: Date().addingTimeInterval(-604800)), // 1 week ago
            attendees: ["user1", "user2", "user3"],
            sharedWith: ["user4", "user5"],
            colorCover: "Red",
            wordCount: 150
        ),
        Wordbook(
            id: UUID().uuidString,
            ownerId: UUID().uuidString,
            title: "Advanced iOS Development",
            isPublic: false,
            dueDate: nil, // No due date
            createdAt: Timestamp(date: Date().addingTimeInterval(-2592000)), // 1 month ago
            attendees: ["user6", "user7"],
            sharedWith: nil, // Not shared with anyone
            colorCover: "Blue",
            wordCount: 300
        ),
        Wordbook(
            id: UUID().uuidString,
            ownerId: UUID().uuidString,
            title: "UI/UX Design Principles",
            isPublic: true,
            dueDate: Timestamp(date: Date().addingTimeInterval(1209600)), // 2 weeks from now
            createdAt: Timestamp(date: Date()), // Now
            attendees: ["user8", "user9", "user10"],
            sharedWith: ["user11"],
            colorCover: "Green",
            wordCount: 200
        )
    ]
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = self.playlistView
        setData()
        setBtn()
        setUI()
    }
    
    func setData(){
        playlistView.resultView.dataSource = self
        playlistView.resultView.delegate = self
        playlistView.resultView.register(PlayingListViewCell.self, forCellReuseIdentifier: "PlayingListViewCell")
    }
    
    func setUI(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setBtn(){
        let popUpButtonClosure = { (action: UIAction) in
                    if action.title == "마감순" {
                        print("마감순")
                    } else if action.title == "인원순" {
                         print("인원순")
                    } else {
                        print("제목순")
                    }
                    //self.tableView.reloadData()
                }
                
        playlistView.filterBtn.menu = UIMenu(
            title: "정렬",
            image: UIImage.filter,
            options: .displayInline,
            children: [
                UIAction(title: "마감순", handler: popUpButtonClosure),
                UIAction(title: "인원순", handler: popUpButtonClosure),
                UIAction(title: "제목순", handler: popUpButtonClosure),]
        )
                
        playlistView.filterBtn.showsMenuAsPrimaryAction = true
        playlistView.filterBtn.changesSelectionAsPrimaryAction = true
    }
    
    func convertTimestampToString(timestamp: Timestamp?) -> String {
        guard let timestamp = timestamp else {
            return "No Date" // 타임스탬프가 nil일 경우 처리
        }
        
        let date = timestamp.dateValue() // Timestamp를 Date로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss" // 날짜 형식 설정
        
        return dateFormatter.string(from: date) // Date를 문자열로 변환하여 반환
    }
    
}

extension PlayingListVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayingListViewCell", for: indexPath) as? PlayingListViewCell else {
                    return UITableViewCell()
                }
        let title = wordBooks[indexPath.row].title
        let date = convertTimestampToString(timestamp: wordBooks[indexPath.row].dueDate)
        let imageData: Data? = UIImage(named: "smileFace")?.pngData()
        cell.listview.bind(imageData: imageData, title: title, date: date)
        cell.nowPplNum = wordBooks[indexPath.row].attendees.count
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedIndexPath = indexPath
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let selectedIndexPath = tableView.indexPathForSelectedRow, selectedIndexPath == indexPath {
            return 160
        } else {
            return 80
        }
    }
    
    
}



