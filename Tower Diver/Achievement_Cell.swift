//
//  Achievement_Cell.swift
//  Tower Diver
//
//  Created by Joe Oliveira on 5/17/19.
//  Copyright © 2019 Alternative Apps Unlimited. All rights reserved.
//

import UIKit

class Achievement_Cell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var CheckImage: UIImageView!
    
}
