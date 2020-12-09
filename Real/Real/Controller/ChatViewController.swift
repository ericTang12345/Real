//
//  ChatViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/8.
//

import UIKit

struct Message {
    
    let receiver: String
    
    let provider: String
    
    let message: String
}

class ChatViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textView: UITextView! {
        
        didSet {
            
            textView.setupBorder(width: 0.8, color: .lightGray)
            
            textView.layer.cornerRadius = 15
            
            textView.text = nil
        }
    }
    
    @IBOutlet weak var sendButton: UIButton! {
        
        didSet {
                
            sendButton.setupBorder(width: 0.8, color: .lightGray)
            
            sendButton.layer.cornerRadius = 15
        }
    }
    
    let mockData: [Message] = [
        Message(receiver: "極品紅茶", provider: "選擇困難的 鴛鴦奶茶", message: "中午吃啥"),
        Message(receiver: "選擇困難的 鴛鴦奶茶", provider: "極品紅茶", message: "每？給？"),
        Message(receiver: "極品紅茶", provider: "選擇困難的 鴛鴦奶茶", message: " (•ิ_•ิ)?")
    ]
    
    override var isHideTabBar: Bool {
        
        return true
    }
    
    override func viewDidLoad () {
        super.viewDidLoad()
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = mockData[indexPath.row]
        
        if message.provider == "選擇困難的 鴛鴦奶茶" {
            
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
