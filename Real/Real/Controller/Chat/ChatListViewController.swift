//
//  ChatListViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/14.
//

import UIKit

class ChatListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var chatList: [ChatRoom] = []
    
    var chatData: ChatRoom?
    
    override var isHideTabBar: Bool { true }
    
    override var segues: [String] { ["SegueToChat"] }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebase.listen(collectionName: .chatRoom) {
            
            self.readChatRomm()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segues[0] {
            
            guard let nextViewController = segue.destination as? ChatViewController else {
                
                return
            }
            
            nextViewController.chat = chatData
        }
    }
    
    func readChatRomm() {
        
        firebase.read(collectionName: .chatRoom, dataType: ChatRoom.self) { (result) in
            
            switch result {
            
            case .success(let data):
                
                guard let user = self.userManager.userData else { return }
                
                var chatList: [ChatRoom] = []
                
                for item in data where item.receiver == user.id || item.provider == user.id {
                    
                    chatList.append(item)
                }
                
                self.chatList = chatList
                
                self.tableView.reloadData()
                
            case .failure(let error):
                
                print("read chat room data error", error.localizedDescription)
            }
        }
    }
}

extension ChatListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.chatData = chatList[indexPath.row]
        
        performSegue(withIdentifier: segues[0], sender: nil)
    }
}

extension ChatListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.reuse(ChatListTableViewCell.self, indexPath: indexPath)
        
        cell.setup(data: chatList[indexPath.row])
    
        return cell
    }
}
