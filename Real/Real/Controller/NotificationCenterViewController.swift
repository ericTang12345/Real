//
//  NotificationCenterViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/1.
//

import UIKit

struct MockData {
    
    let title: String
    
    let content: String
    
    static func mockData() -> [MockData] {
        
        return [
            MockData(title: "漂流信", content: "有漂流信到你的沙灘"),
            MockData(title: "追蹤貼文", content: "你所追蹤的標籤 爆速開發 主題，已經有新的貼文，趕快去查看吧！"),
            MockData(title: "貼文回覆", content: "已經有新的回覆囉！"),
            MockData(title: "透過漂流信已建立起聊天室！", content: "你們透過了緣分搭起來橋樑，趕快去聊天吧！")
        ]
    }
}

class NotificationCenterViewController: BaseViewController {

    override var isHideTabBar: Bool { return true }
    
    let mockData =  MockData.mockData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension NotificationCenterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NotificationCenterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.reuseCell(.notificationCell, indexPath) as? NotificationTableViewCell else {
            
            return .emptyCell
        }
        
        cell.setup(data: mockData[indexPath.row])
        
        return cell
    }
}
