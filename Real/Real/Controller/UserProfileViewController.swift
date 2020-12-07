//
//  UserProfileViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/6.
//

import AuthenticationServices
import FirebaseAuth
import CryptoKit
import FSPagerView

class UserProfileViewController: BaseViewController {

//    @IBOutlet weak var pagerView: FSPagerView! {
//        
//        didSet {
//            
//            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
//            
//            pagerView.delegate = self
//            
//            pagerView.dataSource = self
//            
//            pagerView.transformer = FSPagerViewTransformer(type: .overlap)
//            
//            pagerView.itemSize = CGSize(
//                width: pagerView.frame.width * 0.75,
//                height: pagerView.frame.size.height * 0.9
//            )
//        }
//    }
    
    let authManager = FirebaseAuthManager()
    
    override var isHideTabBar: Bool {
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        signInWithAppleButton.isHidden = true
//        
//        userProfileView.isHidden = false
    }
       
//    @IBAction func signinWithApple(_ sender: CustomizeButton) {
//
//        authManager.performSignin(self)
//    }
}

//extension UserProfileViewController: FSPagerViewDelegate, FSPagerViewDataSource {
//
//    func numberOfItems(in pagerView: FSPagerView) -> Int {
//        return 5
//    }
//
//    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
//
//        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
//
//        cell.setupShadow()
//
//        cell.backgroundColor = .white
//
//        return cell
//    }
//
//    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//
//        print("selected index: \(index)")
//    }
//}
