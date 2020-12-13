//
//  DriftingBottleViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/7.
//

import UIKit

class DriftingBottleViewController: BaseViewController {

    @IBOutlet weak var textView: UITextView! {
        
        didSet {
            
            textView.delegate = self
            
            textView.text = textViewPlaceholder
            
            textView.textColor = .lightGray
        }
    }
    
    @IBOutlet weak var letterView: UIView! {
        
        didSet {
            
            letterView.setupShadow()
        }
    }
     
    let textViewPlaceholder = "今天過得還好嗎？不管是開心、不滿，透過寫信傳達出去吧，不管有沒有人會收到。"
    
    override var isHideKeyboardWhenTappedAround: Bool { return true }
    
    var catcher: String?
    
    let isPost = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 取得隨機 User
    
    func getRandomUser(handler: @escaping () -> Void) {
        
        firebase.read(collectionName: .user, dataType: User.self) { [weak self] (result) in
            
            switch result {
            
            case .success(let data):
                
                let list = data.map { return $0.id }
                
                var id = self?.randomGet(list: list)
                
                while id == UserManager.shared.userData!.id {

                    id = self?.randomGet(list: list)
                }
                
                self?.catcher = id
                
                handler()

            case .failure(let error):
                
                print("get random user error:", error.localizedDescription)
            }
        }
    }
    
    // 隨機從陣列中取出一個
    
    func randomGet(list: [String]) -> String {
        
        if list.count != 0 {
            
            let random = Int.random(in: 0...list.count-1)
            
            return list[random]
            
        } else {
            
            return .empty + "403"
        }
    }
    
    func postDriftingBottle() {
        
        let doc = firebase.getCollection(name: .driftingBottle).document()
        
        let data = DriftingBottle(
            id: doc.documentID,
            content: textView.text,
            isPost: isPost,
            catcher: catcher
        )
        
        self.firebase.save(to: doc, data: data)
    }
    
    @IBAction func saveToFirebase(_ sender: UIButton) {
        
        if isPost {
            
            getRandomUser {
                
                self.postDriftingBottle()
            }
            
        } else {
            
            postDriftingBottle()
        }
    }
}

extension DriftingBottleViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.textColor == UIColor.lightGray {

            textView.text = nil

            textView.textColor = .black
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            
            textView.textColor = UIColor.lightGray
            
            textView.text = textViewPlaceholder
        }
    }
}
