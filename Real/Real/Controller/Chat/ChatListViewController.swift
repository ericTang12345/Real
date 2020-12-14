//
//  ChatListViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/14.
//

import UIKit

class ChatListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override var isHideTabBar: Bool { true }
    
    override var segues: [String] { ["SegueToChat"] }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segues[0] {
            
        }
    }
}

extension ChatListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: segues[0], sender: nil)
    }
}

extension ChatListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.reuseCell(.chatList, indexPath)
        
        cell.textLabel?.text = "Test Cell"
        
        return cell
    }
}
