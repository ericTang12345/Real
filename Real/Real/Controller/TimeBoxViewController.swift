//
//  TimeBoxViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/8.
//

import UIKit
import FSPagerView

class TimeBoxViewController: BaseViewController {

    @IBOutlet weak var pagerView: FSPagerView! {
        
        didSet {
            
            setupPagerView()
        }
    }
    
    @IBOutlet weak var postButton: UIButton! {
        
        didSet {
            
            postButton.isSelected = true
        }
    }
    
    @IBOutlet weak var driftingBottleButton: UIButton!
    
    @IBOutlet weak var collectionButton: UIButton!
    
    var buttons: [UIButton] {
        
        let btns = [postButton!, driftingBottleButton!, collectionButton!]
        
        for (index, btn) in btns.enumerated() {
            
            btn.tag = index
        }
        
        return btns
    }
    
    var selectIndex: Int {
        
        get {
            for btn in buttons where btn.isSelected == true {
                
                return btn.tag
            }
            
            return 0
        }
        
        set {
            
            print("select index", newValue)
            
            pagerView.reloadData()
        }
    }
    
    var posts: [Post] = []
    
    var driftingBottles: [DriftingBottle] = []
    
    var collections: [Post] = []
    
    override var isHideTabBar: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectIndex)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetch()
    }

    func fetch() {
        
        let postFilter = Filter(key: "authorId", value: userManager.userData?.id)
        
        firebase.read(collectionName: .post, dataType: Post.self) { (result) in
            
            switch result {
            
            case .success(let data):
                
                // Posts
                
                var posts: [Post] = []
                
                for item in data where item.authorId == self.userManager.userData?.id {
                    
                    posts.append(item)
                }
                
                self.posts = posts
                
                // Collections
                
                var collections: [Post] = []
                
                for item in data where item.collection.contains(self.userManager.userData!.id) {
                    
                    collections.append(item)
                }
                
                self.collections = collections
                
                self.pagerView.reloadData()
            
            case .failure(let error):
                
                print("Time box fetch post data error:", error)
            }
        }
        
        let driftingBottleFilter = Filter(key: "provider", value: userManager.userData?.id)
        
        firebase.read(collectionName: .driftingBottle, dataType: DriftingBottle.self, filter: driftingBottleFilter) { (result) in
            
            switch result {
            
            case .success(let data):
                
                self.driftingBottles = data
                
                self.pagerView.reloadData()
                
            case .failure(let error):
                
                print("Time box fetch drifting bottle data error:", error)
            
            }
        }
    }
    
    @IBAction func selectButton(sender: UIButton) {
        
        for btn in buttons {
            
            if btn == sender {
                
                btn.isSelected = true
            
                selectIndex = btn.tag
                
            } else {
                
                btn.isSelected = false
            }
        }
    }
}

extension TimeBoxViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func setupPagerView() {
        
        let postNib = UINib.initialize(nibName: FrontCollectionViewCell.nibName)
        
        self.pagerView.register(postNib, forCellWithReuseIdentifier: CellId.post.rawValue)
        
        let driftingBottleNib = UINib.initialize(nibName: DriftingBottlePagerViewCell.nibName)
        
        self.pagerView.register(driftingBottleNib, forCellWithReuseIdentifier: CellId.driftingBottle.rawValue)
        
        pagerView.scrollDirection = .horizontal

        pagerView.delegate = self
        
        pagerView.dataSource = self
        
        pagerView.setupShadow()
        
        pagerView.transformer = FSPagerViewTransformer(type: .overlap)
        
        pagerView.itemSize = CGSize(
            width: pagerView.frame.width * 0.8,
            height: pagerView.frame.size.height * 0.9
        )
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        switch selectIndex {
        
        case 0: return posts.count
        
        case 1: return driftingBottles.count
        
        case 2: return collections.count
            
        default: return 0
        
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        switch selectIndex {
        
        case 0:
            
            guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellId.post.rawValue, at: index) as? FrontCollectionViewCell else {
                
                return FSPagerViewCell()
            }
            
            cell.setup(data: posts[index])
            
            return cell
        
        case 1:
            
            guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellId.driftingBottle.rawValue, at: index) as? DriftingBottlePagerViewCell else {
                
                return FSPagerViewCell()
            }
            
            cell.setup(data: driftingBottles[index])
            
            return cell
        
        case 2:
            
            guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellId.post.rawValue, at: index) as? FrontCollectionViewCell else {
                
                return FSPagerViewCell()
            }
            
            cell.setup(data: collections[index])

            return cell
            
        default: return FSPagerViewCell()
        
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
        print("pagerView selected index: \(index)")
    }
}
