//
//  PostEditViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/23.
//

import UIKit

protocol textViewContentDelegate: AnyObject {
    
    func getContent() -> String
}

class PostEditViewController: BaseViewController {

    @IBOutlet weak var userImageView: UIImageView!

    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var postTypeLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: textViewContentDelegate?
    
    var post: Post?
    
    override var enableHideKeyboardWhenTappedAround: Bool { return true }
    
    override var enableKeyboardNotification: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        
        guard let post = post else { return }
        
        userImageView.loadImage(urlString: post.authorImage)
        
        userNameLabel.text = post.authorName
        
        postTypeLabel.text = post.type
    }
    
    @IBAction func editDone(_ sender: UIButton) {
        
        guard let post = post, let delegate = delegate else { return }
        
        let doc = firebase.getCollection(name: .post).document(post.id)
        
        doc.updateData([
            
            "content": delegate.getContent()
        ])
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
}

extension PostEditViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostEditTableViewCell", for: indexPath) as? PostEditTableViewCell,
              let post = post
        else {
            
            return .emptyCell
        }
    
        cell.setup(text: post.content, tableView: tableView)
        
        delegate = cell
        
        return cell
    }
}
