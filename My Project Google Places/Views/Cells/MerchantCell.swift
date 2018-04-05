//
//  MerchantCell.swift
//  My Project Google Places
//
//  Created by Nikola Popovic on 4/2/18.
//  Copyright © 2018 Nikola Popovic. All rights reserved.
//

import UIKit

class MerchantCell: UITableViewCell {
    
    @IBOutlet weak var name : UILabel!
    @IBOutlet weak var imageOfMerchant: UIImageView!
    @IBOutlet weak var address : UILabel!
    @IBOutlet weak var donationDirective : UILabel!
    @IBOutlet weak var arrow : UIImageView!
    @IBOutlet weak var checkMarkIcon : UIImageView!
    @IBOutlet weak var iWantThisMerchant : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageOfMerchant.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
