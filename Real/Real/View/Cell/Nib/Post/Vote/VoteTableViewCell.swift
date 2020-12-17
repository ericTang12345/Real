//
//  VoteTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/16.
//

import UIKit

class VoteTableViewCell: UITableViewCell {

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.registerCellWithNib(cell: VoteItemTableViewCell.self)
            
            tableView.delegate = self
            
            tableView.dataSource = self
        }
    }
    
    var votes: [String] = [] {
        
        didSet {
            
            tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(data: Post) {
        
        votes = data.vote
    }
}

extension VoteTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return votes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
         return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return .micronView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return .micronView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.reuse(VoteItemTableViewCell.self, indexPath: indexPath)
        
        cell.voteTitleLabel.text = votes[indexPath.row]
        
        return cell
    }

}
