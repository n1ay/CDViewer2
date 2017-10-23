
//
//  CD.swift
//  CDViewer
//
//  Created by Kamil on 23/10/2017.
//  Copyright © 2017 Kamil Kos. All rights reserved.
//

import Foundation

class CD {
    
    var artist: String
    var genre: String
    var album: String
    var year: Int
    var tracks: Int
    
    init() {
        artist = ""
        genre = ""
        album = ""
        year = 0
        tracks = 0
    }
    
    init(dict: [String: Any]) {
        self.artist = dict["artist"] as! String
        self.genre = dict["genre"] as! String
        self.album = dict["album"] as! String
        self.year = dict["year"] as! Int
        self.tracks = dict["tracks"] as! Int
    }
    
}
