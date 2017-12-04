//
//  UserView.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 21.11.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import Foundation
import UIKit

class UserView {
    
    static func setCircularLogoImage(image: UIImageView) {
        image.image = User.sharedUser.photo
        image.layer.borderWidth = 3
        image.layer.masksToBounds = true
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
    }
}
