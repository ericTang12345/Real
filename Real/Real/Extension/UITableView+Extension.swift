//
//  UITableView+Extension.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/26.
//

import UIKit
import Foundation

extension UITableView {
    
    // Nib
    
    func registerCellWithNib(cell: UITableViewCell.Type) {
        
        let nib = UINib(nibName: cell.nibName, bundle: nil)
        
        register(nib, forCellReuseIdentifier: cell.defaultReuseIdentifier)
    }
    
    // Cell
    
    func reuse(_ id: CellId, indexPath: IndexPath) -> UITableViewCell {
        
        return self.dequeueReusableCell(withIdentifier: id.rawValue, for: indexPath)
    }
    
    func reuse<T: UITableViewCell>(_ cell: T.Type, indexPath: IndexPath) -> T {
        
        guard let cell = self.dequeueReusableCell(withIdentifier: cell.defaultReuseIdentifier, for: indexPath) as? T else {
            
            fatalError()
        }
        
        return cell
    }
    
    enum CellType {
        
        case main(PostMainTableViewCell.Type)
        
        case tag(TagListTableViewCell.Type)
        
        case image(PostImageTableViewCellNib.Type)
        
        case vote(VoteTableViewCell.Type)
        
        case interaction(InteractionTableViewCell.Type)
        
    }
    
    // register all nib
    
    func registerNib() {
        
        self.registerCellWithNib(cell: PostMainTableViewCell.self)
        
        self.registerCellWithNib(cell: InteractionTableViewCell.self)
        
        self.registerCellWithNib(cell: PostImageTableViewCell.self)
        
        self.registerCellWithNib(cell: PostImageTableViewCellNib.self)
        
        self.registerCellWithNib(cell: CommentTableViewCell.self)
        
        self.registerCellWithNib(cell: VoteTableViewCell.self)
        
        self.registerCellWithNib(cell: TagListTableViewCell.self)
    }
    
    func sortByCell(_ post: Post) -> [CellType] {
        
        var cellType: [CellType] = [.main(PostMainTableViewCell.self)]
        
        if !post.images.isEmpty {
            
            cellType.append(.image(PostImageTableViewCellNib.self))
        }
        
        if !post.votes.isEmpty {

            cellType.append(.vote(VoteTableViewCell.self))
        }
        
        if !post.tags.isEmpty {

            cellType.append(.tag(TagListTableViewCell.self))
        }
        
        cellType.append(.interaction(InteractionTableViewCell.self))
        
        return cellType
    }
}
