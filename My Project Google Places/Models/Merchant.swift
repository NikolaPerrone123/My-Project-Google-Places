//
//  Merchant.swift
//  My Project Google Places
//
//  Created by Nikola Popovic on 4/2/18.
//  Copyright © 2018 Nikola Popovic. All rights reserved.
//

import Foundation
import UIKit

class Merchant {
    var id : String!
    var name : String!
    var image : UIImage!
    var address : String!
    var isRegistred : Bool!
    var donationDirective : String!
    
    init() {
        self.id = ""
        self.name = ""
        self.image = UIImage()
        self.address = ""
        self.isRegistred = false
        self.donationDirective = ""
    }
}
