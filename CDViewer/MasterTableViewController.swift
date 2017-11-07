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
    var JSONdata: [Any] = []
    var actualIndex: Int = 0
    var minIndex: Int = 0
    var maxIndex: Int = 0
    
    @IBOutlet weak var addNewRecordButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDataFromFile()
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
                    self.serializeJSON(data)
                    self.convertDataToCD()
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
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let CD = CDdata[indexPath.row]
                let detail = (segue.destination as! UINavigationController).topViewController as! DetailView
                
                detail.Album = CD
                detail.index = indexPath.row
                detail.maxIndex = CDdata.endIndex
                detail.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                detail.navigationItem.leftItemsSupplementBackButton = true
            }
        } else if segue.identifier == "addNew" {
            let detail = (segue.destination as! UINavigationController).topViewController as! DetailView
            detail.Album = CD()
            detail.index = CDdata.endIndex
            detail.maxIndex = CDdata.endIndex+1
            detail.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            detail.navigationItem.leftItemsSupplementBackButton = true
            CDdata.append(CD())
            maxIndex+=1
            tableView.reloadData()
        }
    }
    
    @IBAction func segueBackDelete (segue: UIStoryboardSegue) {
        let source = segue.source as! DetailView
        CDdata.remove(at: source.index)
        if maxIndex > 0 {
            maxIndex-=1
        }
        tableView.reloadData()
    }
    
    @IBAction func segueBackSave (segue: UIStoryboardSegue) {
        let source = segue.source as! DetailView
        source.setCD()
        CDdata[source.index] = source.Album
        tableView.reloadData()
    }
    
    func loadDataFromFile() {
        let dirPaths =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let docsDir = dirPaths.first {
            let myFilePath = docsDir + "albums.txt"
            if checkIfFileExists() {
                print("exists")
                JSONdata = NSArray.init(contentsOfFile:  myFilePath) as! [Any]
                convertDataToCD()
            } else {
                (JSONdata as NSArray).write(toFile: myFilePath, atomically: true)
                print("doesn't exists")
            }
        }
    }
    
    func serializeJSON(_ data: Data?) {
        if let usableData = data {
            JSONdata = try! JSONSerialization.jsonObject(with: usableData, options: []) as! [Any];
        }
    }
    
    func convertDataToCD() {
        for iter in JSONdata {
            if let obj = iter as? [String: Any] {
                self.CDdata.append(CD(dict: obj))
            }
        }
        self.maxIndex = self.CDdata.endIndex-1
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func checkIfFileExists() -> Bool {
        let documentsURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fooURL = documentsURL.appendingPathComponent("albums.txt")
        return FileManager().fileExists(atPath: fooURL.path)
    }
    
}
