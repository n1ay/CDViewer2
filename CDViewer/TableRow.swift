//
//  TableRow.swift
//  CDViewer
//
//  Created by Użytkownik Gość on 24.10.2017.
//  Copyright © 2017 Kamil Kos. All rights reserved.
//

import UIKit

class TableRow: UITableViewCell {

    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
