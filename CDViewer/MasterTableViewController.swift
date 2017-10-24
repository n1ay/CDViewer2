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
    
    var CDdata: [CD] = []
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
                        let data = try! JSONSerialization.jsonObject(with: usableData, options: []) as! [Any];
                        for iter in data {
                            if let obj = iter as? [String: Any] {
                                self.CDdata.append(CD(dict: obj))
                            }
                        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableRow
        
        let idx=indexPath.row
                cell.albumLabel.text = CDdata[idx].album
                cell.artistLabel.text = CDdata[idx].artist
                cell.yearLabel.text = String(CDdata[idx].year)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let CD = CDdata[indexPath.row]
            let detail = (segue.destination as! UINavigationController).topViewController as! DetailView
            
            detail.Album = CD
            detail.index = indexPath.row
            detail.maxIndex = CDdata.endIndex
            detail.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            detail.navigationItem.leftItemsSupplementBackButton = true
        }
        
    }
    

}
