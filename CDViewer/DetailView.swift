//
//  DetailView.swift
//  CDViewer
//
//  Created by Kamil on 22/10/2017.
//  Copyright © 2017 Kamil Kos. All rights reserved.
//

import Foundation
import UIKit

class DetailView: UITableViewController {
    
    var CD: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setCD(CD: [String: Any]) {
        self.CD = CD
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        /*switch indexPath.row {
            case 0: cell.textLabel?.text = CD["artist"] as? String
            case 1: cell.textLabel?.text = CD["album"] as? String
            case 2: cell.textLabel?.text = CD["genre"] as? String
            case 3: cell.textLabel?.text = String((CD["year"] as? Int)!)
            case 4: cell.textLabel?.text = String((CD["tracks"] as? Int)!)
            default: cell.textLabel?.text = ""
        }*/
        return cell
    }
}

