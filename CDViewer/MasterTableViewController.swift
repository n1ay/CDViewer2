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
                            let obj = iter as! [String: Any]
                            self.CDdata.append(CD(dict: obj))
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
        var cell = UITableViewCell()
        var count = 0
        for idx in 0...maxIndex {
            if count == indexPath.row {
                cell.textLabel?.text = CDdata[idx].album
                break
            }
            count+=1
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let detail = segue.destination as? DetailView {
                if let index = sender as? IndexPath {
                    detail.Album = CDdata[index.row]
                    detail.index = index.row
                    detail.maxIndex = CDdata.endIndex
                    detail.viewDidLoad()
                    detail.setTextFields()
                }
            }
        }
    }

}
