//
//  MasterTableViewController.swift
//  CDViewer
//
//  Created by Kamil on 21/10/2017.
//  Copyright © 2017 Kamil Kos. All rights reserved.
//

import Foundation
import UIKit

class MasterTableViewController: UITableViewController {
    
    var CDdata: [Any] = []
    var actualIndex: Int = 0
    var minIndex: Int = 0
    var maxIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData(){
        let urlString = URL(string: "https://isebi.net/albums.php")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let usableData = data {
                        self.CDdata = try! JSONSerialization.jsonObject(with: usableData, options: []) as! [Any];
                        self.maxIndex = self.CDdata.endIndex-1
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            task.resume()
        }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CDdata.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        var count = 0
        for idx in 0...maxIndex {
            var cd = CDdata[idx] as? [String: Any]
            if count == indexPath.row {
                cell.textLabel?.text = cd!["album"] as? String
                break
            }
            count+=1
        }
        
        return cell
    }
}
