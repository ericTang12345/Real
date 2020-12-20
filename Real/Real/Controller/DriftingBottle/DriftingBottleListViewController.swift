//
//  DriftingBottleListViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/18.
//

import UIKit

class DriftingBottleListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var driftingBottles: [DriftingBottle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    }

}

extension DriftingBottleListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DriftingBottleListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return driftingBottles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriftingBottleListCell", for: indexPath)
        
        cell.textLabel?.text = driftingBottles[indexPath.row].providerName
        
        cell.detailTextLabel?.text = driftingBottles[indexPath.row].content
        
        return cell
    }
}
