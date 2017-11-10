//
//  WelcomeViewController.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 31.10.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user.setUserDefaults(user: user)
        Utilities.setCircularLogoImage(image: profileImage)
        
        if let photo = user.photo as? UIImage {
            profileImage.image = photo
        }
        
        if let username = user.username as? String {
            userName.text = username
        }
        
    }
}
