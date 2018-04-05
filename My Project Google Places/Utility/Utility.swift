//
//  File.swift
//  My Project Google Places
//
//  Created by Nikola Popovic on 4/4/18.
//  Copyright © 2018 Nikola Popovic. All rights reserved.
//

import Foundation
import UIKit

open class Utility {
    
    class func formatNavBar(navBar : UINavigationBar){
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.backgroundColor = .clear
    }
}
