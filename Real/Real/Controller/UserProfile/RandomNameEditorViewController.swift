//
//  RandomNameEditorViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/9.
//

import UIKit

class RandomNameEditorViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var tableData: [String] = []
    
    var mainNames: [RandomMainName] = []
    
    var adjNames: [RandomAdjName] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebase.listen(collectionName: .randomAdjName) {
            
            self.readAdj()
            
            self.reloadTableData()
        }
        
        firebase.listen(collectionName: .randomMainName) {
            
            self.readMain()
            
            self.reloadTableData()
        }
    }
    
    func reloadTableData() {
        
        switch segmentedControl.selectedSegmentIndex {
        
        case 0:
            
            adjNames.sort { (first, second) -> Bool in
                
                return first.id > second.id
            }
            
            tableData = adjNames.map({ (data) -> String in
                
                return data.name
            })
            
        case 1:
            
            mainNames.sort { (first, second) -> Bool in
                
                return first.id > second.id
            }
            
            tableData = mainNames.map({ (data) -> String in
                        
                return data.name
            })
            
        default:
            
            print("segmentedControl is nil")
        }
        
        tableView.reloadData()
    }
    
    func save(text: String) {
        
        if text != .empty {
            
            switch segmentedControl.selectedSegmentIndex {
            
            case 0:
                
                let doc = firebase.getCollection(name: .randomAdjName).document()
                
                var id = Int()
                
                if adjNames.count == 0 {
                    
                    id = 1
                    
                } else {
                    
                    id = adjNames[0].id + 1
                }
                
                let adjData = RandomAdjName(id: id, name: text)
                
                firebase.save(to: doc, data: adjData)
                
            case 1:
                
                let doc = firebase.getCollection(name: .randomMainName).document()
                
                var id = Int()
                
                if mainNames.count == 0 {
                    
                    id = 1
                    
                } else {
                    
                    id = mainNames[0].id + 1
                }
                
                let mainData = RandomMainName(id: id, name: text)
                
                firebase.save(to: doc, data: mainData)
                    
            default: break
                
            }
        }
    }
    
    @IBAction func switchData(_ sender: UISegmentedControl) {

        reloadTableData()
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        let title = segmentedControl.selectedSegmentIndex == 0 ? "形容詞" : "主詞"
        
        let alert = UIAlertController(title: "新增", message: "請輸入想要增加的\(title)\n勿超過 10 個字", preferredStyle: .alert)

        let done = UIAlertAction(title: "加入", style: .default) { (_) in

            guard let textField = alert.textFields?[0], let text = textField.text else { return }

            if text.count > 10 {

                self.present(alert, animated: true) {

                    alert.view.shake()
                }

            } else {

                self.save(text: text)

                self.reloadTableData()
            }

        }

        alert.addAction(done)

        let cancel = UIAlertAction(title: "返回", style: .default, handler: nil)

        alert.addAction(cancel)

        alert.addTextField { (textField) in

            textField.placeholder = title
        }

        present(alert, animated: true, completion: nil)
    }
}

extension RandomNameEditorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RandomNameCell", for: indexPath)
        
        cell.textLabel?.text = tableData[indexPath.row]
        
        return cell
    }
}

extension RandomNameEditorViewController {
    
    func readMain() {
        
        firebase.read(collectionName: .randomMainName, dataType: RandomMainName.self) { [weak self] result in
            
            switch result {
            
            case .success(let data):
                
                self?.mainNames = data
                
                self?.reloadTableData()
                
            case .failure(let error):
                
                print("read random main name is fail", error.localizedDescription)
            }
        }
    }
}

extension RandomNameEditorViewController {
    
    func readAdj() {
        
        firebase.read(collectionName: .randomAdjName, dataType: RandomAdjName.self) { result in
            
            switch result {
            
            case .success(let data):
                                
                self.adjNames = data
                
                self.reloadTableData()
                            
            case .failure(let error):
                
                print("read random adj name is fail", error.localizedDescription)
            }
        }
    }
}
