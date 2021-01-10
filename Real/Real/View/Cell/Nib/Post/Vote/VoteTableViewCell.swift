//
//  VoteTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/16.
//

import UIKit

class VoteTableViewCell: BaseTableViewCell {

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.registerCellWithNib(cell: VoteItemTableViewCell.self)
            
            tableView.delegate = self
            
            tableView.dataSource = self
        }
    }
    
    weak var delegate: InteractionTableViewCellDelegate?
    
    var post: Post?
    
    var votes: [Vote] = [] {
        
        didSet {
            
            total = 0
            
            _ = votes.map { total += $0.voter.count }
        }
    }
    
    var total: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(data: Post) {
        
        self.post = data
        
        guard let post = post else { return }
        
        let collection = firebase.getCollection(name: .post).document(post.id).collection("votes")
        
        firebase.listen(collection: collection) {
            
            self.reload()
        }
    }
    
    func reload() {
        
        guard let post = post else { return }
        
        let collection = firebase.getCollection(name: .post).document(post.id).collection("votes")
        
        firebase.read(collection: collection, dataType: Vote.self) { (result) in
            
            switch result {
            
            case .success(let data):
                
                self.votes = data.sorted(by: { (first, second) -> Bool in
                    
                    return first.id < second.id
                })
                
                self.tableView.reloadData()
            
            case .failure(let error):
                
                print("read vote data fail", error.localizedDescription)
            }
        }
    }
}

extension VoteTableViewCell: UITableViewDelegate {
    
}

extension VoteTableViewCell: UITableViewDataSource {
    
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
        
        guard let post = post else { return .emptyCell }
        
        cell.setup(data: votes[indexPath.row], post: post, total: total)
        
        cell.delegate = delegate
        
        return cell
    }
}
