//
//  ClientTableViewCell.swift
//  ProofOfConcept
//
//  Created by Trevor Doodes on 19/03/2017.
//  Copyright © 2017 Ironworks Media Ltd. All rights reserved.
//

import UIKit

class ClientTableViewCell: UITableViewCell {

    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var siteIdLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
