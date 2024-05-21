//
//  TestResultViewController.swift
//  WordWideWeb
//
//  Created by 박준영 on 5/20/24.
//

import UIKit

class TestResultViewController: UIViewController {
    
    // MARK: - properties
    private let testView = TestResultView()
    
    var block: [[String:String]] = [
        ["word": "Algorithm", "definition": "A set of rules or steps to solve a problem or perform a task."],
        ["word": "API", "definition": "Application Programming Interface - A set of rules and tools for building software applications."],
        ["word": "Backend", "definition": "The server-side part of a web application that interacts with databases and other external systems."],
        ["word": "Debugging", "definition": "The process of finding and fixing errors or bugs in software code."],
        ["word": "Framework", "definition": "A reusable set of libraries or tools used to develop software applications."],
        ["word": "IDE", "definition": "Integrated Development Environment - A software application that provides comprehensive facilities to programmers for software development."],
        ["word": "Repository", "definition": "A storage location for software packages and version control data."],
        ["word": "Syntax", "definition": "The set of rules that defines the combinations of symbols that are considered to be correctly structured programs in a specific programming language."],
        ["word": "Variable", "definition": "A symbolic name that is associated with a value and whose associated value may be changed."],
        ["word": "Bug", "definition": "An error, flaw, failure, or fault in a computer program or system that causes it to produce an incorrect or unexpected result."]
    ]
    
    var result: [Status] = []
    var wrongwordList: [String] = []
    
    private var rightCount = 0 {
        didSet {
            testView.bind(quizNum: quizCount, rightNum: rightCount, wrongNum: wrongCount)
        }
    }
    private var wrongCount = 0 {
        didSet {
            testView.bind(quizNum: quizCount, rightNum: rightCount, wrongNum: wrongCount)
        }
    }
    private var quizCount = 0 {
        didSet {
            testView.bind(quizNum: quizCount, rightNum: rightCount, wrongNum: wrongCount)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = self.testView
        setData()
        makeWrongWordsList()
        print("TestResultViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.setNeedsDisplay()
    }
    
    func setData(){
        testView.wrongwordLabel.dataSource = self
        testView.wrongwordLabel.delegate = self
        testView.wrongwordLabel.register(BlockCell.self, forCellWithReuseIdentifier: "BlockCell")
        testView.okBtn.addTarget(self, action: #selector(okBtnDidTapped), for: .touchUpInside)
    }
    
    @objc func okBtnDidTapped(){
        let tabBar = TabBarController()
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
    }
    
    func bind(status: [Status]){
        self.result = status
        calculateScore()
    }
    
    func calculateScore(){
        quizCount = result.count
        testView.quizNumLabel.text = String(result.count)
        for res in result{
            switch res {
            case .right:
                rightCount += 1
            case .wrong:
                wrongCount += 1
            case .none:
                wrongCount += 1
            }
        }
    }
    
    func makeWrongWordsList(){
        var index = 0
        for res in result {
            if res != .right {
                if let wrongword = block[index]["word"] {
                    wrongwordList.append(wrongword)
                }
            }
            index += 1
        }
    }
    
}

extension TestResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wrongCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlockCell", for: indexPath) as! BlockCell
        cell.bind(text: wrongwordList[indexPath.row])
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = wrongwordList[indexPath.row]
        let font = UIFont.systemFont(ofSize: 16)
        let textWidth = text.size(withAttributes: [NSAttributedString.Key.font: font]).width
        let cellWidth = textWidth + 20
        return CGSize(width: cellWidth, height: 28)
    }
    
}

