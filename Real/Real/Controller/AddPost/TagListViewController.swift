//
//  TagListViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/24.
//

import UIKit

protocol TagListViewControllerDelegate: AnyObject {
    
    func dismiss(viewController: UIViewController)
    
    func passTagData(viewController: UIViewController, tags: [Tag])
}

class TagListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            
            tableView.dataSource = self
            
            tableView.registerCellWithNib(cell: TagListTableViewCell.self)
        }
    }
    
    weak var delegate: TagListViewControllerDelegate?
    
    var tagListView: TagListView? {
        
        didSet {
            
            tagListView?.dataSource = self
            
            tagListView?.delegate = self
        }
    }
    
    var selectTagListView: TagListView? {
        
        didSet {
            
            selectTagListView?.dataSource = self
            
            selectTagListView?.delegate = self
        }
    }
    
    var tags: [Tag] = []
    
    var selectTags: [Tag] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebase.listen(collectionName: .tag) {
            
            self.reload()
        }
    }
    
    func reload() {
        
        firebase.read(collectionName: .tag, dataType: Tag.self) { (result) in
            
            switch result {
            
            case .success(let data):
                
                self.tags = data.sorted(by: { (first, second) -> Bool in
                    
                    return first.color < second.color
                })
            
                self.tableView.reloadData()
                
            case .failure(let error):
                
                print("read Tag data fail error in TagListAlertViewController:", error)
            
            }
        }
    }
    
    @IBAction func didTapToAddTag(_ sender: UIButton) {
        
        self.delegate?.passTagData(viewController: self, tags: selectTags)
        
        self.delegate?.dismiss(viewController: self)
        
        selectTags = []
        
        tableView.reloadData()
    }
    
    @IBAction func didTapToCancel(_ sender: UIButton) {

        self.delegate?.dismiss(viewController: self)
        
        selectTags = []
        
        tableView.reloadData()
    }
}

extension TagListViewController: TagListViewDataSource {
    
    func numberOfTag(view: TagListView) -> Int {
        
        return view == selectTagListView ? selectTags.count: tags.count
    }
    
    func dataForTag(view: TagListView, index: Int) -> Tag {
        
        return view == selectTagListView ? selectTags[index] : tags[index]
    }
}

extension TagListViewController: TagListViewDelegate {
    
    func buttonDidTap(view: TagListView, tag: Tag) {
        
        if view == tagListView {
            
            if selectTags.count == 4 {
                
                present(.alertMessage(title: "標籤限制", message: "一則貼文只能選擇四個標籤"), animated: true, completion: nil)
                
                return
            }
            
            if !selectTags.contains(tag) {
                
                selectTags.append(tag)
            }
            
        } else {
            
            for (index, selecTag) in selectTags.enumerated() where selecTag == tag {
                
                selectTags.remove(at: index)
            }
        }

        tableView.reloadData()
    }
}

extension TagListViewController: UITableViewDelegate {
}

extension TagListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.section {
        
        case 0: return selectTagListView?.frame.height ?? 0
            
        case 1: return tagListView?.frame.height ?? 0
        
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return section == 0 ? "這則貼文的標籤" : "標籤列表"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        
        case 0:
            
            let cell = tableView.reuse(TagListTableViewCell.self, indexPath: indexPath)
            
            self.selectTagListView = cell.tagList
            
            cell.tagList.dataSource = self
            
            return cell
            
        case 1:
            
            let cell = tableView.reuse(TagListTableViewCell.self, indexPath: indexPath)
            
            self.tagListView = cell.tagList
            
            cell.tagList.dataSource = self
            
            return cell
            
        default: return .emptyCell
            
        }
    }
    
}
