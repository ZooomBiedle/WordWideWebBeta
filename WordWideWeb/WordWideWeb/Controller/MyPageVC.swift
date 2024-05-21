//
//  MyPageVC.swift
//  WordWideWeb
//
//  Created by 박준영 on 5/17/24.
//

import UIKit
import SnapKit

class MyPageVC: UIViewController {
    
    // 좌상단 타이틀 : string만 변경해서 공통 사용
    lazy var topLabel = LabelFactory().makeLabel(text: "WordWideWeb")
    // 좌상단 로고 : 공통 사용
    lazy var topLogo = ImageFactory().makeImage()
    // 우하단 버튼 : 공통 사용
    lazy var circleBtn = ButtonFactory().makeButton(corner: 22, width: 44, size: 50.0)
    
    // 단어장 카드 collectionView
    var collection: UICollectionView = {
        let layout = CarouselLayout()
        
        layout.itemSize = CGSize(width: 297, height: 450)
        layout.sideItemScale = 175/251
        layout.spacing = -175
        layout.isPagingEnabled = true
        layout.sideItemAlpha = 0.5
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
     //  view.showsHorizontalScrollIndicator = false  // 자동으로 horizontal인것을 꺼주기
        
        view.backgroundColor = UIColor(named: "bgColor")
        view.register(MyPageCollectionViewCell.self, forCellWithReuseIdentifier: "MyPageCollectionViewCell")
        return view
    }()
    
    // 홈 화면 단어 카드에 들어가는 정보 Array
    var myPageList = [MyPage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bgColor")
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupViews()
        collecctionSetup()
        
        //더미 데이터 생성
        makeDummy(count: 2)
        
//        let dummy = MyPage(word: ["let"], title: "개발자 필수 영단어", name: "jiyeon", image: "cross")
//        let dummy1 = MyPage(word: ["let"], title: "개발자 필수 영단어", name: "jiyeon", image: "cross")
//        let dummy2 = MyPage(word: ["let"], title: "개발자 필수 영단어", name: "jiyeon", image: "cross")
        circleBtn.addAction(UIAction(handler: { _ in
        }), for: .touchUpInside)
        
        //생성된 더미데이터를 배열(myPageList)에 저장
//        myPageList.append(dummy)
//        myPageList.append(dummy1)
//        myPageList.append(dummy2)
    }
        
    func makeDummy(count: Int) {
        for i in 0...count-1 {
            let dummy = MyPage(word: ["let"], title: "개발자 필수 영단어", name: "jiyeon", image: "cross")
            myPageList.append(dummy)
        }
    }
    
    func setupViews() {
        view.addSubview(topLabel)
        view.addSubview(topLogo)
        view.addSubview(circleBtn)
        view.addSubview(collection)
  
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(63)
        }
        
        topLogo.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(82)
            make.leading.equalToSuperview().offset(17)
            make.trailing.equalTo(topLabel.snp.leading).offset(-2)
            make.bottom.equalToSuperview().offset(-725)
        }
        
        circleBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(707)
            make.leading.equalToSuperview().offset(300)
            make.bottom.equalToSuperview().offset(-100)
        }
        
        collection.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.leading.equalToSuperview().offset(45)
            make.trailing.equalToSuperview().offset(-45)
            make.bottom.equalToSuperview().offset(-170)
        }
    }
}

