//
//  ViewController.swift
//  CDViewer
//
//  Created by Użytkownik Gość on 10.10.2017.
//  Copyright © 2017 Kamil Kos. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class ViewController: UIViewController {

    var CDdata: [Any] = []
    var actualIndex: Int = 0
    var minIndex: Int = 0
    var maxIndex: Int = 0
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var newButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var trackField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var genreField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
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
                            self.updateTextFields()
                            self.currentTrackUpdate()
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func updateTextFields() {
        if let CD = self.CDdata[self.actualIndex] as? [String: Any] {
            self.authorField.text = CD["artist"] as? String
            self.genreField.text = CD["genre"] as? String
            self.titleField.text = CD["album"] as? String
            let year = CD["year"] as? Int
            let tracks = CD["tracks"] as? Int
            self.yearField.text = String(year!)
            self.trackField.text = String(tracks!)
        }
    }
    
    func currentTrackUpdate() {
        self.previousButton.isEnabled = true
        self.numberLabel.text = "\(self.actualIndex+1) z \(self.maxIndex+1)"
        if(self.actualIndex == self.minIndex) {
            self.previousButton.isEnabled = false
        };
        self.saveButton.isEnabled = false
    }
    
    func createNewRecord() {
        authorField.text = ""
        genreField.text = ""
        titleField.text = ""
        yearField.text = "0"
        trackField.text = "0"
        actualIndex = maxIndex+1
        maxIndex+=1
        saveButton.isEnabled = true
        currentTrackUpdate()
        var cd = [String: Any]()
        cd["artist"] = ""
        cd["genre"] = ""
        cd["album"] = ""
        cd["tracks"] = 0
        cd["year"] = 0
        CDdata.append(cd)
    }
    
    func saveRecord() {
        var cd = (CDdata[actualIndex] as! [String: Any])
        cd["artist"] = authorField.text
        cd["genre"] = genreField.text
        cd["album"] = titleField.text
        cd["year"] = Int(yearField.text!)
        cd["tracks"] = Int(trackField.text!)
        CDdata[actualIndex] = cd
    }

    @IBAction func onTextFieldEdit(_ sender: UITextField) {
        saveButton.isEnabled = true
    }
    @IBAction func deletePressed(_ sender: Any) {
        CDdata.remove(at: actualIndex)
        if(minIndex == maxIndex) {
            self.maxIndex-=1
            self.actualIndex-=1
            createNewRecord()
            return
        }
        else if(actualIndex == maxIndex) {
            actualIndex-=1
        }
        self.maxIndex-=1
        self.updateTextFields()
        self.currentTrackUpdate()

    }
    @IBAction func newPressed(_ sender: Any) {
        createNewRecord()
    }
    @IBAction func savePressed(_ sender: Any) {
        saveRecord()
    }
    @IBAction func previousPressed(_ sender: Any) {
        self.actualIndex-=1
        self.updateTextFields()
        self.currentTrackUpdate()
    }
    @IBAction func nextPressed(_ sender: Any) {
        if(actualIndex == maxIndex) {
            createNewRecord()
            return
        }
        self.actualIndex+=1
        self.updateTextFields()
        self.currentTrackUpdate()
    }
}

