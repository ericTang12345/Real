//
//  VoteTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/14.
//

import UIKit

class VoteItemTableViewCell: BaseTableViewCell {

    @IBOutlet weak var circleButton: UIButton!
    
    @IBOutlet weak var percentageLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var voteTitleLabel: UILabel!
    
    weak var delegate: InteractionTableViewCellDelegate?
    
    var vote: Vote?
    
    var post: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(data: Vote, post: Post, total: Int) {
        
        self.vote = data
        
        self.post = post
        
        voteTitleLabel.text = data.title + " (\(data.voter.count) 票)"
            
        let voteCount = getVoterCount(voter: data.voter.count, total: total)
        
        progressView.progress = voteCount
        
        percentageLabel.text = total == 0 ? "" : "\(Int(voteCount*100)) %"
        
        guard let user = userManager.userData else { return }
        
        circleButton.isSelected = data.voter.contains(user.id)
    }
    
    // 如果曾對這個議題投過票，會把其他的複寫掉
    
    func checkIsVoted() {
        
        guard let post = post else { return }
        
        let collection = firebase.getCollection(name: .post).document(post.id).collection("votes")
        
        firebase.read(collection: collection, dataType: Vote.self) { (result) in
            
            switch result {
            
            case .success(let data):
                
                guard let user = self.userManager.userData else { return }
                
                for item in data where item.id != self.vote?.id {
                    
                    collection.document(item.docId).updateData([
                        
                        "voter": FIRFieldValue.arrayRemove([user.id])
                    ])
                }
                
            case .failure(let error):
                
                print("check Is Voted read vote fail", error.localizedDescription)
            }
        }
    }
    
    // 算出佔比給 progressView
    
    func getVoterCount(voter: Int, total: Int) -> Float {
        
        if total == 0 { return 0 }
        
        if voter == total { return 1 }
        
        return Float(Double(voter) / Double(total))
    }
    
    @IBAction func vote(_ sender: UIButton) {
        
        if !userManager.isSignin {
            
            delegate?.signinAlert(cell: self)
            
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        guard let vote = vote, let post = post, let user = userManager.userData else { return }
        
        let collection = firebase.getCollection(name: .post).document(post.id).collection("votes").document(vote.docId)
        
        if vote.voter.contains(user.id) {
            
            collection.updateData([
                
                "voter": FIRFieldValue.arrayRemove([user.id])
            ])
            
        } else {
            
            collection.updateData([
                
                "voter": FIRFieldValue.arrayUnion([user.id])
            ])
            
            checkIsVoted()
        }
    }
}
