//
//  LobbyTableViewCell.swift
//  Tankz
//
//  Created by Thomas Markussen on 06/03/2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import UIKit

class LobbyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var readyStatusLabel: UILabel!
    @IBOutlet weak var readyStatusIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
