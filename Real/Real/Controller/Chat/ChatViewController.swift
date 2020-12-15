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
        
        return firebase.getCollection(name: .chatRoom).document("Ig1anZKX7T7uHmoZKw4a")
    }
    
    var messages: [Message] = []
    
    override var isHideTabBar: Bool { return true }
    
    override var isHideKeyboardWhenTappedAround: Bool { return false }
    
    override func viewDidLoad () {
        super.viewDidLoad()

        firebase.listen(collectionName: .chatRoom) {
            
            self.reloadChat()
        }
    }
    
    func reloadChat() {
        
        firebase.read(collectionName: .chatRoom, dataType: Message.self) { (result) in
            
            switch result {
            
            case .success(let data):
                
                self.messages = data.sorted(by: { (firest, second) -> Bool in
                    
                    firest.createdTime.dateValue() < second.createdTime.dateValue()
                })
                
                self.tableView.reloadData()
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func replyComment(_ sender: UIButton) {
        
        let newMessage = Message(message: textField.text!)
        
        let doc = firebase.getCollection(name: .chatRoom).document()
        
        firebase.save(to: doc, data: newMessage)
        
        textField.text = nil
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        if message.sender == userManager.userID {
            
            guard let cell = tableView.reuseCell(.userMessage, indexPath) as? UserMessageTableViewCell else {

                return .emptyCell
            }

            cell.messageLabel.text = message.message
            
            return cell
        
        } else {
            
            guard let cell = tableView.reuseCell(.receiverMessage, indexPath) as? ReceiverTableViewCell else {

                return .emptyCell
            }

            cell.messageLabel.text = message.message

            return cell
        }
    }
}
