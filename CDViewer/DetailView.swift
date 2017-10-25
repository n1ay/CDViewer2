//
//  DetailView.swift
//  CDViewer
//
//  Created by Kamil on 22/10/2017.
//  Copyright © 2017 Kamil Kos. All rights reserved.
//

import Foundation
import UIKit

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

class DetailView: UITableViewController {
    
    var Album: CD = CD()
    var index: Int = 0
    var maxIndex: Int = 0
    
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var tracksTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        saveButton.isEnabled = false
        setTextFields()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setTextFields() {
        if Album.isEqual(to: CD()) {
            tracksTextField.text = ""
            yearTextField.text = ""
        } else {
            yearTextField.text = String(Album.year)
            tracksTextField.text = String(Album.tracks)
        }
        authorTextField.text = Album.artist
        titleTextField.text = Album.album
        genreTextField.text = Album.genre
        navigationBar.title = "Edycja rekordu \(index+1) z \(maxIndex)"
    }
    
    func setCD() {
        Album.artist = authorTextField.text!
        Album.album = titleTextField.text!
        Album.genre = genreTextField.text!
        if let year = Int(yearTextField.text!) {
            Album.year = year
        }
        if let tracks = Int(yearTextField.text!) {
            Album.tracks = tracks
        }
    }
    
    @IBAction func onTextFieldChanged(_ sender: UITextField) {
        saveButton.isEnabled = true
    }
    
}

