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
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    var doc: DocumentReference {
        
        return firebase.getCollection(name: .chatRoom).document(chat!.id)
    }
    
    var chat: ChatRoom?
    
    var messages: [Message] = []
    
    override var isHideTabBar: Bool { return true }
    
    override var isEnableHideKeyboardWhenTappedAround: Bool { return true }
    
    override var isEnableKeyboardNotification: Bool { true }
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
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
                        
                    case .failure(let error):
                    
                        print("decode message error", error.localizedDescription)
                    }
                }
            }
        }
    }
    
    @IBAction func replyComment(_ sender: UIButton) {
        
        let newMessage = Message(message: textField.text!)
        
        let doc = firebase.getCollection(name: .chatRoom).document(chat!.id).collection("messages").document()
        
        firebase.save(to: doc, data: newMessage)
        
        firebase.update(collectionName: .chatRoom, documentId: chat!.id, key: "lastMessage", value: textField.text)
        
        firebase.update(collectionName: .chatRoom, documentId: chat!.id, key: "lastMessageTime", value: FIRTimestamp())
        
        textField.text = nil
        
        textField.endEditing(true)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        if message.sender == userManager.userID {
            
            let cell = tableView.reuse(UserMessageTableViewCell.self, indexPath: indexPath)

            cell.setup(data: message)
            
            return cell
        
        } else {
            
            let cell = tableView.reuse(ReceiverTableViewCell.self, indexPath: indexPath)

            let image = chat!.provider == userManager.userData!.id ? chat!.receiverImage : chat!.providerImage
            
            cell.setup(data: message, image: image)
            
            return cell
        }
    }
}
