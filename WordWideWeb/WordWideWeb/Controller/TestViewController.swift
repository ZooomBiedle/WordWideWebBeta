//
//  TestViewController.swift
//  WordWideWeb
//
//  Created by 신지연 on 2024/05/18.
//

import UIKit

enum Status {
    case right
    case wrong
    case none
}

class TestViewController: UIViewController {
    
    // MARK: - properties
    private let testView = TestView()
    private var secondLeft: Int = 180
    
    var taskname: String = "개발자를 위한 영단어 10"
    var taskmem: [String] = ["지연", "나연", "준영", "진영"]
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
    
    private var currentIndex: Int = 0
    private var answer: String = ""
    private var status: [Status] = []
    private var timer: Timer?
    
    // MARK: - life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view = self.testView
        setData()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - method
    func setData(){
        testView.friendView.register(TestFriendViewCell.self, forCellWithReuseIdentifier: "TestFriendViewCell")
        testView.friendView.dataSource = self
        testView.friendView.delegate = self
        testView.answerLabel.delegate = self
        testView.totalPageLabel.text = " of \(block.count)"
        testView.nextBtn.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
        testView.beforeBtn.addTarget(self, action: #selector(beforeBtnTapped), for: .touchUpInside)
        testView.submitBtn.addTarget(self, action: #selector(checkAnswer), for: .touchUpInside)
        testView.beforeBtn.isEnabled = false
        
        status = Array(repeating: .none, count: block.count)
        
        setTimer()
        reloadQView()
    }
    
    func setTimer(){
        secondLeft = 10
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (t) in
            //남은 시간(초)에서 1초 빼기
            self.secondLeft -= 1
            
            //남은 분
            let minutes = self.secondLeft / 60
            //그러고도 남은 초
            let seconds = self.secondLeft % 60
            
            //남은 시간(초)가 0보다 크면
            if self.secondLeft > 0 {
                self.testView.timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
            } else {
                self.testView.timeLabel.text = "시간 끝!"
                self.timer?.invalidate()
                self.moveToResultView()
            }
        })
    }
    
    func reloadQView(){
        if let def = block[currentIndex]["definition"] {
            testView.bindQ(page: currentIndex+1, definition: def)
        }
        if let word = block[currentIndex]["word"] {
            answer = word
        }
        switch status[currentIndex] {
        case .right:
            testView.answerLabel.isEnabled = false
            testView.submitBtn.isEnabled = false
            isAlreadySolveAndRight()
        case .wrong:
            testView.answerLabel.isEnabled = false
            testView.submitBtn.isEnabled = false
            isAlreadySolveAndWrong()
        case .none:
            testView.answerLabel.isEnabled = true
            testView.submitBtn.isEnabled = true
            isNotSolved()
        }
    }
    
    func moveToResultView(){
        let resultVC = TestResultViewController()
        resultVC.bind(status: status)
        resultVC.modalPresentationStyle = .fullScreen
        self.present(resultVC, animated: true)
    }
    
    func isAlreadySolveAndRight(){
        testView.questionView.layer.borderColor = UIColor.green.cgColor
        testView.questionView.layer.borderWidth = 2
        testView.submitBtn.isEnabled = false
    }
    
    func isAlreadySolveAndWrong(){
        testView.questionView.layer.borderColor = UIColor.red.cgColor
        testView.questionView.layer.borderWidth = 2
        testView.submitBtn.isEnabled = false
    }
    
    func isNotSolved(){
        testView.questionView.layer.borderWidth = 0
    }
    
    
    @objc func checkAnswer(){
        guard let userInput = testView.answerLabel.text else {
            print("No answer entered")
            return
        }
        if answer == userInput {
            status[currentIndex] = .right
            print("right!")
            reloadQView()
        } else {
            status[currentIndex] = .wrong
            print("wrong")
            reloadQView()
        }
        print(status)
        if !status.contains(.none){
            moveToResultView()
        }
    }
    
    @objc func nextBtnTapped(){
        testView.answerLabel.text = ""
        if currentIndex < block.count - 2 {
            testView.beforeBtn.isEnabled = true
            currentIndex += 1
            reloadQView()
        } else if currentIndex == block.count - 2 {
            currentIndex += 1
            testView.nextBtn.isEnabled = false
            testView.beforeBtn.isEnabled = true
            reloadQView()
        } else {
            testView.nextBtn.isEnabled = false
            testView.nextBtn.isEnabled = true
        }
    }
    
    @objc func beforeBtnTapped(){
        testView.answerLabel.text = ""
        if currentIndex == 1 {
            currentIndex -= 1
            testView.beforeBtn.isEnabled = false
            testView.nextBtn.isEnabled = true
            reloadQView()
        } else {
            currentIndex -= 1
            reloadQView()
            testView.nextBtn.isEnabled = true
        }
    }

}

// MARK: - extension
extension TestViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskmem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestFriendViewCell", for: indexPath) as! TestFriendViewCell
        return cell
    }
}

extension TestViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            let transform = CGAffineTransform(translationX: 0, y: -200)
            self.view.transform = transform
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            let transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.transform = transform
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkAnswer()
        return true
    }
}
