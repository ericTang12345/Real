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

class AddNewPostViewController: UIViewController {
    
    weak var contentDelegate: AddNewPostContentDelegate?
    
    weak var authorDelegate: AddNewPostAuthorDelegate?
    
    let firebase = FirebaseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backToRoot(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveToFirebase(_ sender: UIBarButtonItem) {
        
        guard let content = contentDelegate?.getContent(),
              let type = authorDelegate?.getPostType(),
              let authorName = authorDelegate?.getAuthorName(),
              let authorImage = authorDelegate?.getAuthorImage()
        else {
            return
        }
        
        let createdTime = firebase.currentTimestamp
        
        let document = firebase.getCollection(name: .post).document()
        
        let post = Post(id: document.documentID,
                        type: type,
                        image: .empty,
                        content: content,
                        likeCount: [],
                        createdTime: createdTime,
                        authorId: "test",
                        authorName: authorName,
                        authorImage: authorImage,
                        tags: [],
                        vote: [])
        
        firebase.save(to: document, data: post)
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddNewPostViewController: UITableViewDelegate {
    
}

extension AddNewPostViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        
        case 0:
            
            guard let cell = tableView.reuseCell(.postTitle, indexPath) as? PostTitleTableViewCell else {
                
                return .emptyCell
            }
            
            self.authorDelegate = cell
            
            return cell
            
        case 1:
            
            guard let cell = tableView.reuseCell(.postContent, indexPath) as? PostContentTableViewCell else {
                
                return .emptyCell
            }
            
            cell.setup(tableView)
            
            self.contentDelegate = cell
            
            return cell
            
        default:
            
            return .emptyCell
        }
    }
}
