//
//  ChatViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/8.
//

import UIKit
import Firebase

class ChatViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textView: UITextView! {
        
        didSet {
            
            textView.delegate = self
        }
    }
    
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    
    var doc: DocumentReference {
        
        return firebase.getCollection(name: .chatRoom).document(chat!.id)
    }
    
    var chat: ChatRoom?
    
    var messages: [Message] = []
    
    override var isHideTabBar: Bool { return true }
    
    override var isEnableHideKeyboardWhenTappedAround: Bool { return true }
    
    override var isEnableKeyboardNotification: Bool { return true }
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
        listenMessage()
    }
    
    func listenMessage() {
        
        doc.collection("messages").addSnapshotListener { (querySnapshot, error) in
            
            if error != nil {
                
                print("listen chat room messages fail", error!.localizedDescription)
            }
            
            if querySnapshot != nil {
                
                self.firebase.decode(Message.self, documents: querySnapshot!.documents) { (result) in
                    
                    switch result {
                    
                    case .success(let data):
                        
                        self.messages = data.sorted(by: { (first, second) -> Bool in
                            
                            first.createdTime.dateValue() < second.createdTime.dateValue()
                        })
                        
                        self.tableView.reloadData()
                        
                        self.scrolltoBottom()
                    
                    case .failure(let error):
                    
                        print("decode message error", error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func scrolltoBottom() {
        
        let row = (messages.count - 1)
        
        tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .bottom, animated: true)
        
        tableView.reloadData()
    }
    
    @IBAction func replyComment(_ sender: UIButton) {
        
        guard let user = userManager.userData else { return }
        
        let newMessage = Message(id: user.id, message: textView.text!)
        
        let doc = firebase.getCollection(name: .chatRoom).document(chat!.id).collection("messages").document()
        
        firebase.save(to: doc, data: newMessage)
        
        firebase.update(collectionName: .chatRoom, documentId: chat!.id, key: "lastMessage", value: textView!.text!)
        
        firebase.update(collectionName: .chatRoom, documentId: chat!.id, key: "lastMessageTime", value: FIRTimestamp())
        
        textView.text = nil
        
        textView.endEditing(true)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        guard let user = userManager.userData else {
            
            print("ChatViewController no user data")
            
            return .emptyCell
        }
        
        if message.sender == user.id {
            
            let cell = tableView.reuse(UserMessageTableViewCell.self, indexPath: indexPath)

            cell.setup(data: message, tableView: tableView)
            
            return cell
        
        } else {
            
            let cell = tableView.reuse(ReceiverTableViewCell.self, indexPath: indexPath)
            
            let image = chat!.provider == user.id ? chat!.receiverImage : chat!.providerImage
            
            cell.setup(data: message, image: image)
            
            return cell
        }
    }
}

extension ChatViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (textView.text.count + text.count - range.length) == 0 {
            
            placeholderLabel.isHidden = false
            
        } else {
            
            placeholderLabel.isHidden = true
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        placeholderLabel.isHidden = true
        
        textView.text = nil
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.count == 0 {
            
            placeholderLabel.isHidden = false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.textCountLines() <= 10 {
            
            NSLayoutConstraint.activate([
                textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
            ])
            
            textView.isScrollEnabled = false
            
        } else {
            
            NSLayoutConstraint.activate([
                textView.heightAnchor.constraint(equalToConstant: 200)
            ])
            
            textView.isScrollEnabled = true
        }
    }
}
