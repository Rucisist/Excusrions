//
//  theTableViewCell.swift
//  mapProject
//
//  Created by Андрей Илалов on 21.07.17.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import UIKit

class theTableViewCell: UITableViewCell {
    @IBOutlet weak var theNameLabel: UILabel!
    @IBOutlet weak var theTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
