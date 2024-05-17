//
//  TestIntroViewController.swift
//  WordWideWeb
//
//  Created by 신지연 on 2024/05/17.
//

import UIKit

class TestIntroViewController: UIViewController {
    
    private let testView = TestIntroView()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view = self.testView

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
