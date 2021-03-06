//
//  DriftingBottleViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/7.
//

import UIKit

class DriftingBottleViewController: BaseViewController {

    @IBOutlet weak var currentCountLabel: UILabel!
    
    @IBOutlet weak var chatBadgeLabel: UILabel! {
        
        didSet {
            
            chatBadgeLabel.setup(cornerRadius: chatBadgeLabel.height/2)
        }
    }
    
    @IBOutlet weak var writeDriftingBottleButton: UIButton! {
        
        didSet {
            
            writeDriftingBottleButton.setup(cornerRadius: writeDriftingBottleButton.height/2)
        }
    }

    @IBOutlet weak var bottleImageView: UIImageView! {
        
        didSet {
            
            bottleImageView.enableTapAction(sender: self, selector: #selector(openDriftingBottle))
        }
    }
    
    @IBOutlet weak var badgeLabel: UILabel! {
        
        didSet {
            
            badgeLabel.setup(cornerRadius: 15)
        }
    }
    
    @IBOutlet weak var centerView: UIView!
    
    var driftingBottles: [DriftingBottle] = []
    
    var timer = Timer()
    
    override var segues: [String] { return ["SeugeWriteLetter", "SegueLookLetter", "SegueChatList"] }
    
    override var isHideNavigationBar: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebase.listen(collectionName: .driftingBottle) {
            
            self.readDriftingBottle()
        }
        
        firebase.listen(collectionName: .chatRoom) {
            
            self.readChatRoom()
        }
        
        FIRStore.firestore().collectionGroup("messages").addSnapshotListener { (_, _) in
            
            self.readChatRoom()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(readDriftingBottle), userInfo: nil, repeats: true)
        
        readDriftingBottle()
        
        centerView.layer.add(addWaveAnimation(), forKey: "Wave")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timer.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let nextViewControoler = segue.destination as? LetterViewController else { return }
        
        if segue.identifier == segues[0] {
            
            nextViewControoler.status = .add
            
            nextViewControoler.writeDoneDelegate = self
        }
        
        if segue.identifier == segues[1] {
            
            nextViewControoler.status = .look
            
            nextViewControoler.bottleData = driftingBottles[0]
            
            firebase.getCollection(name: .driftingBottle).document(driftingBottles[0].id).updateData([
                
                "isCatch": true
            ])
        }
    }
    
    func readChatRoom() {
        
        guard let user = userManager.userData else { return }
        
        firebase.read(collectionName: .chatRoom, dataType: ChatRoom.self) { (result) in
            
            switch result {
            
            case .success(let data):
                
                var count = 0
                
                for item in data where item.provider == user.id || item.receiver == user.id {
                    
                    let collection = self.firebase.getCollection(name: .chatRoom).document(item.id).collection("messages")
                    
                    self.firebase.read(collection: collection, dataType: Message.self) { (result) in
                        
                        switch result {
                        
                        case .success(let data):
                        
                            for item in data where item.isRead == false && item.sender != user.id {
                                
                                count += 1
                            }
                            
                            self.chatBadgeLabel.isHidden = count == 0 ? true : false
                            
                            self.chatBadgeLabel.text = String(count)
                            
                        case .failure(let error):
                            
                            print(error)
                        }
                    }
                }
                
            case .failure(let error):
            
                print(error)
            }
        }
    }
    
    @objc func readDriftingBottle() {
        
        let filter = Filter(key: "isPost", value: true)
        
        driftingBottles = []
        
        firebase.read(collectionName: .driftingBottle, dataType: DriftingBottle.self, filter: filter) { (result) in
            
            switch result {
            
            case .success(let data):
                
                // 已抵達
                var isArrivaleds: [DriftingBottle] = []
                
                // 未抵達
                var isNotArrivaleds: [DriftingBottle] = []
                
                for item in data where item.isCatch == false {

                    if self.compare(data: item) {
                        
                        isArrivaleds.append(item)
                        
                    } else {
                        
                        isNotArrivaleds.append(item)
                    }
                }
            
                self.setup(isArrivaleds, isNotArrivaleds)
            
            case .failure(let error):
                
                print("read Drifting Bottle error: ", error)
            
            }
        }
    }
    
    func compare(data: DriftingBottle) -> Bool {
        
        guard let user = userManager.userData else { return false }
        
        if data.catcher != user.id {
            
            print("This drifting bottle catcher not this user")
            
            return false
        }
        
        if data.arrivalTime!.dateValue() > FIRTimestamp().dateValue() {
            
            print("This drifting bottle is not arrival")
            
            return false
        }
        
        return true
    }
    
    func setup(_ isArrivaleds: [DriftingBottle], _ isNotArrivaleds: [DriftingBottle]) {
        
        self.driftingBottles = isArrivaleds
        
        self.currentCountLabel.text =
        """
        目前總共有 \(isNotArrivaleds.count) 個漂流瓶
        還在大海中漂流
        尚未抵達某人手中
        """
        
        guard let receive = userManager.userData?.isReceiveDriftingBottle else {
            
            return
        }
        
        if isArrivaleds.count == 0 || receive == false {
            
            self.badgeLabel.isHidden = true
            
        } else {
            
            self.badgeLabel.isHidden = false
            
            self.badgeLabel.text = String(isArrivaleds.count)
        }
    }
    
    @objc func openDriftingBottle() {
        
        if driftingBottles.isEmpty {
            
            let message =
            """
            目前還沒有收到漂流瓶哦
            可能還未抵達，先去寫封漂流信吧
            """
            
            present(.alertMessage(title: "沒有收到漂流瓶", message: message), animated: true, completion: nil)
            
        } else {
            
            performSegue(withIdentifier: segues[1], sender: nil)
        }
    }
    
    @IBAction func showChatList(_ sender: UIButton) {
        
        if !userManager.isSignin {
            
            present(.signinAlert(handler: {
                
                let viewController = SigninWithAppleViewController.loadFromNib()
                
                viewController.modalPresentationStyle = .fullScreen
                
                viewController.delegate = self
                
                viewController.loadViewIfNeeded()
                
                self.present(viewController, animated: true, completion: nil)
                
            }), animated: true, completion: nil)
            
            return
        }
        
        performSegue(withIdentifier: segues[2], sender: nil)
    }
}

extension DriftingBottleViewController {
    
    func addWaveAnimation() -> CAKeyframeAnimation {
        
        let animation = CAKeyframeAnimation()
        
        animation.keyPath = "position"
        
        animation.duration = 300 // 60 seconds
        
        animation.isAdditive = true // Make the animation position values that we later generate relative values.
    
        // From x = 0 to x = 299, generate the y values using sine.
        animation.values = (1...450).map({ (xPoint: Int) -> NSValue in
            
            let xPos = CGFloat(xPoint)
            
            let yPos = sin(xPos)
            
            let point = CGPoint(x: 0, y: yPos * 15)
            
            // The 10 is to give it some amplitude.
            return NSValue(cgPoint: point)
        })
            
        return animation
    }
}

extension DriftingBottleViewController: LetterWriteDoneDeleage {
    
    func writeDone(status: SignatureStatus) {
        
        var message = String()
        
        switch status {
        
        case .signature: message =
        """
        你的漂流信將會透過大海抵達某人手中
        也許會透過此信連結彼此
        """

        case .anonymous: message =
        """
        已將你現在的心情送往大海
        你可以到 個人 - 時光寶盒
        查看你的漂流瓶紀錄
        """
        
        }
        DispatchQueue.main.async {
            
            self.present(.alertMessage(title: "送出漂流瓶", message: message), animated: true, completion: nil)
        }
    }
}
