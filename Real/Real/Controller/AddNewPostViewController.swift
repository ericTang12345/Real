//
//  AddNewPostViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/1.
//

import UIKit

protocol AddNewPostContentDelegate: AnyObject {
    
    func getContent() -> String
}

protocol AddNewPostAuthorDelegate: AnyObject {
    
    func getPostType() -> String
    
    func getAuthorImage() -> String
    
    func getAuthorName() -> String
}

class AddNewPostViewController: BaseViewController {
    
    @IBOutlet var userView: UIView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var postTypeButton: UIButton!
    
    @IBOutlet weak var toolView: UIView!
    
    weak var contentDelegate: AddNewPostContentDelegate?
    
//    let firebase = FirebaseManager.shared
    
//    let userManager = UserManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadView()
    }
    
    @objc func reloadView() {
        
        userImageView.loadImage(urlString: userManager.userData!.randomImage)
        
        userNameLabel.text = userManager.userData?.randomName
    }
    
    @IBAction func backToRoot(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveToFirebase(_ sender: UIBarButtonItem) {
        
        guard let content = contentDelegate?.getContent(),
              let type = postTypeButton.currentTitle
        else {
            return
        }
        
        let doc = firebase.getCollection(name: .post).document()
        
        let post = Post(id: doc.documentID, type: type, image: .empty, content: content, tags: [], vote: [])
        
        firebase.save(to: doc, data: post)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchPostType(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
    }
}

extension AddNewPostViewController: UITableViewDelegate {
    
}

extension AddNewPostViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return userView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return userView.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.reuseCell(.postContent, indexPath) as? PostContentTableViewCell else {
            
            return .emptyCell
        }
        
        cell.setup(tableView)
        
        self.contentDelegate = cell
        
        return cell
    }
}