//
//  TopicSettingViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/14.
//

import UIKit

protocol TopicSettingViewControllerDelegate: AnyObject {
    
    func sendTopicSetting(voteItems: [String], textCount: Int)
}

class TopicSettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var voteSectionView: UIView!
    
    weak var delegate: TopicSettingViewControllerDelegate?
    
    var textCountList = [0, 15, 30, 60]
    
    var voteItems: [String] = []
    
    var textCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addNewVoteItem(_ sender: UIButton) {
        
        let config = AlertConfig(title: "新增", message: "請輸入你想要加入的投票項目", placeholder: "投票項目")
        
        present(.alertTextField(config: config, handler: { (text) in
            
            self.voteItems.append(text)
            
            self.tableView.reloadData()
            
        }), animated: true, completion: nil)
    }
    
    @IBAction func completedSetting(_ sender: UIBarButtonItem) {
        
        delegate?.sendTopicSetting(voteItems: self.voteItems, textCount: textCount)
    }
    
}

extension TopicSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            voteItems.remove(at: indexPath.row)
            
            tableView.reloadData()
        }
    }
}

extension TopicSettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        
        case 0: return 1
        
        case 1: return voteItems.count
            
        default: return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        
        case 0: return nil
        
        case 1: return voteSectionView
            
        default: return nil
        
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        
        case 0: return "詳細設定"
        
        case 1: return nil
            
        default: return nil
        
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCount", for: indexPath)
            
            cell.textLabel?.text = "字數限制"
            
            cell.detailTextLabel?.text = "30"
        
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "VoteItemCell", for: indexPath)
            
            cell.textLabel?.text = voteItems[indexPath.row]
            
            return cell
            
        default: return .emptyCell
            
        }
    }
}
