//
//  LetterViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/17.
//

import UIKit

protocol LetterViewControllerDelegate: AnyObject {
    
    func getContent() -> String
}

protocol LetterWriteDoneDeleage: AnyObject {
    
    func writeDone(status: SignatureStatus)
}

enum LetterStatus {
    
    case add
    
    case look
}

enum SignatureStatus {
    
    case signature
    
    case anonymous
}

class LetterViewController: BaseViewController {

    @IBOutlet var headerView: UIView!
    
    @IBOutlet var footerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var createdTimeLabel: UILabel! {
        
        didSet {
            
            createdTimeLabel.text = FIRTimestamp().timeStampToStringDetail()
        }
    }
    
    @IBOutlet weak var signatureButton: UIButton!
    
    @IBOutlet weak var bottomButton: UIButton! {
        
        didSet {
            
            switch status {
            
            case .add: bottomButton.setTitle("發出漂流瓶", for: .normal)
            
            case .look: bottomButton.setTitle("建立聊天室", for: .normal)
            
            }
        }
    }
    
    weak var delegate: LetterViewControllerDelegate?
    
    weak var writeDoneDelegate: LetterWriteDoneDeleage?
    
    var status: LetterStatus = .add
    
    var catcher: String?
    
    var isPost = false
    
    var bottleData: DriftingBottle?
    
    override var isEnableHideKeyboardWhenTappedAround: Bool { return true }
    
    override var isHideNavigationBar: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setupShadow()
        
        if status == .look {
            
            guard let data = bottleData else { return }
            
            createdTimeLabel.text = data.createdTime.timeStampToStringDetail()
            
            signatureButton.setTitle(data.providerName, for: .normal)
        }
    }
    
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
        
        guard let delegate = delegate else { return }
        
        let data = DriftingBottle(
            id: doc.documentID,
            content: delegate.getContent(),
            isPost: isPost,
            catcher: catcher
        )
        
        firebase.save(to: doc, data: data)
    }
    
    func send() {
        
        if isPost {
            
            getRandomUser { self.postDriftingBottle() }
            
            writeDoneDelegate?.writeDone(status: .signature)
            
        } else {
            
            postDriftingBottle()
            
            writeDoneDelegate?.writeDone(status: .anonymous)
        }
    }
    
    func connect() {
        
        guard let data = bottleData else { return }
        
        firebase.update(collectionName: .driftingBottle, documentId: data.id, key: "isCatch", value: true)
        
        let doc = firebase.getCollection(name: .chatRoom).document()
        
        let chatRoom = ChatRoom(id: doc.documentID, receiver: data)
        
        firebase.save(to: doc, data: chatRoom)
    }
    
    @IBAction func signature(_ sender: UIButton) {
        
        if status == .add {
            
            if sender.isSelected {
                
                sender.setTitle("Signature", for: .normal)
                
            } else {
                
                let title = "By: " + (userManager.userData?.randomName ?? "")
                
                sender.setTitle(title, for: .normal)
            }
            
            sender.isSelected = !sender.isSelected
            
            isPost = sender.isSelected
        }
    }
    
    @IBAction func sendOrConnect(_ sender: UIButton) {
        
        switch status {
        
        case .add: send()
        
        case .look: connect()
        
        }
    
        self.dismiss(animated: true, completion: nil)
    }
}

extension LetterViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension LetterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.reuse(LetterTableViewCell.self, indexPath: indexPath)
        
        cell.setup(data: bottleData, tableView: self.tableView, status: status)
        
        delegate = cell
        
        return cell
    }
}
