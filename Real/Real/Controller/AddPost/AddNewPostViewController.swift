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

struct VoteSetting {
    
    let voteTime: Int
    
    let textCount: Int
}

enum PostType {
    
    case post
    
    case topic
}

class AddNewPostViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var postTypeButton: UIButton!
    
    @IBOutlet weak var voteButton: UIButton! {
        
        didSet {
            
            voteButton.isSelected = false
        }
    }
    
    @IBOutlet weak var toolView: UIView!
    
    weak var contentDelegate: AddNewPostContentDelegate?
    
    var images: [UIImage] = []
    
    var voteItems: [String] = []
    
    var voteSetting = VoteSetting(voteTime: 1, textCount: 30)
    
    var postType: PostType = .post
    
    override var isEnableHideKeyboardWhenTappedAround: Bool { true }
    
    override var isEnableKeyboardNotification: Bool { true }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadView()
    }
    
    @objc func reloadView() {
        
        userImageView.loadImage(urlString: userManager.userData!.randomImage)
        
        userNameLabel.text = userManager.userData?.randomName
    }
    
    func getImage(type: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = true
        
        imagePicker.sourceType = type
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func getUrl(id: String, handler: @escaping ([String]) -> Void) {
        
        var urls: [String] = []
        
        for image in images {
            
            storage.uploadImage(image: image, folder: .post, id: id) { (result) in
                
                switch result {
                
                case .success(let url):
                    
                    urls.append(url)

                    if urls.count == self.images.count {
                        
                        handler(urls)
                    }
                
                case .failure(let error):
                    
                    print("upload image fail, error:", error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - IBAction function
    
    // left back button
    
    @IBAction func backToRoot(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
        view.endEditing(true)
    }
    
    // post button
    
    @IBAction func saveToFirebase(_ sender: UIBarButtonItem) {
        
        // 資料檢查
        
        guard let content = contentDelegate?.getContent(), content != .empty else {
            
            present(.alertMessage(title: "錯誤", message: "內容不可以為空"), animated: true, completion: nil)
            
            return
        }
        
        guard let type = postTypeButton.currentTitle else { return }
        
        // 開始進行儲存
        
        let doc = firebase.getCollection(name: .post).document()
        
        var post = Post(id: doc.documentID, type: type, images: [], content: content, tags: [], vote: voteItems)
        
        // 圖片
    
        if images.isEmpty {
            
            self.firebase.save(to: doc, data: post)
            
            dismiss(animated: true, completion: nil)
            
        } else {
            
            getUrl(id: doc.documentID) { (urls) in
                
                post.images = urls
                
                self.firebase.save(to: doc, data: post)
                
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        view.endEditing(true)
    }
    
    // type button
    
    @IBAction func switchPostType(_ sender: UIButton) {
    
        switch postType {
        
        case .post:
            
            postType = .topic
            
            voteButton.isEnabled = true
            
            voteButton.imageView?.tintColor = .black
            
        case .topic:
    
            postType = .post
            
            voteButton.isEnabled = false
            
            voteButton.imageView?.tintColor = .lightGray
            
            voteItems = []
        }
        
        tableView.reloadData()
        
        sender.isSelected = !sender.isSelected
        
        view.endEditing(true)
    }
    
    @IBAction func openCamera(_ sender: UIButton) {
    
        if images.count != 4 {
            
            getImage(type: .camera)
        
        } else {
            
            present(.alertMessage(title: "圖片限制", message: "圖片只能上傳四張"), animated: true, completion: nil)
        }
        
        view.endEditing(true)
    }
    
    @IBAction func openPhotoAlbun(_ sender: UIButton) {
        
        if images.count != 4 {
            
            getImage(type: .photoLibrary)
        
        } else {
            
            present(.alertMessage(title: "圖片限制", message: "圖片只能上傳四張"), animated: true, completion: nil)
        }
        
        view.endEditing(true)
    }
    
    @IBAction func addVoteItem(_ sender: UIButton) {
        
        view.endEditing(true)
        
        let config = AlertConfig(title: "新增", message: "請輸入你想要加入的投票項目", placeholder: "投票項目")
        
        present(.alertTextField(config: config, handler: { (text) in
            
            if text != .empty {
                
                self.voteItems.append(text)
                
                self.tableView.reloadData()
            }
            
        }), animated: true, completion: nil)
    }
}

// MARK: - UIImageViewPickerController Delegate

extension AddNewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            
            images.append(image)
            
            tableView.reloadData()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableView delegate & dataSource

extension AddNewPostViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {

        case 0, 1: return 1
            
        case 2: return voteItems.count == 0 ? 0 : 1
            
        case 3: return voteItems.count

        default: return 0

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        
        case 0:
            
            let cell = tableView.reuse(PostContentTableViewCell.self, indexPath: indexPath)
            
            self.contentDelegate = cell
            
            cell.tableView = self.tableView
            
            return cell
            
        case 1:
            
            let cell = tableView.reuse(PostImageTableViewCell.self, indexPath: indexPath)

            cell.images = self.images
            
            return cell
            
        case 2:
            
            let cell = tableView.reuse(VoteSettingTableViewCell.self, indexPath: indexPath)
            
            cell.setup(voteSetting)
            
            return cell
            
        case 3:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "VoteCell", for: indexPath)
            
            cell.textLabel?.text =  "選項 \(indexPath.row+1) :  \(voteItems[indexPath.row])"
            
            return cell
            
        default: return .emptyCell
        
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        
        case 1: return images.count == 0 ? UITableView.automaticDimension : 150
        
        case 3: return 30
            
        default: return UITableView.automaticDimension
            
        }
    }
}
