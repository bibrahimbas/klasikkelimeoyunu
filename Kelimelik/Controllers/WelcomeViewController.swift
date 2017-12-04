//
//  WelcomeViewController.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 31.10.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import UIKit
import WCLShineButton

class WelcomeViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var heartsStack: UIStackView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPhotoDefaults()
        DataService.sharedInstance.setUserDefaults()
        UserView.setCircularLogoImage(image: profileImage)
        
        if let username = User.sharedUser.username as? String {
            userName.text = username
        }
        if let score = User.sharedUser.scoreTotal as? Int {
            scoreLabel.text = String(score)
        }
    }
    
    func setPhotoDefaults() {
        profileImage.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(photoImagePressed))
        profileImage.addGestureRecognizer(tapRecognizer)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func photoImagePressed() {
        performSegue(withIdentifier: "directProfileSegue", sender: User.sharedUser)
    }
    
    
}
