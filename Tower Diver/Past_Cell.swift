//
//  Past_Cell.swift
//  Tower Diver
//
//  Created by Joe Oliveira on 5/19/19.
//  Copyright © 2019 Alternative Apps Unlimited. All rights reserved.
//

import UIKit

class Past_Cell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var ClassImage: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Details: UILabel!
    @IBOutlet weak var DiedImage: UIImageView!
}
