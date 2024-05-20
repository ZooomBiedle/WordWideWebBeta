//
//  TestIntroViewController.swift
//  WordWideWeb
//
//  Created by 신지연 on 2024/05/17.
//

import UIKit

class TestIntroViewController: UIViewController {
    
    
    // MARK: - properties
    private let testView = TestIntroView()
    
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
    
    // MARK: - life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view = self.testView
        
        setData()
    }
    
    // MARK: - method
    
    func setData(){
        testView.bind(title: taskname, blockCount: block.count)
        testView.startBtn.addTarget(self, action: #selector(didTappedStartBtn), for: .touchUpInside)
    }
    
    @objc private func didTappedStartBtn() {
        self.dismiss(animated: true)
        let testViewController = TestViewController()
        testViewController.modalPresentationStyle = .fullScreen
        present(testViewController, animated: true)
        
    }
    
    
}

