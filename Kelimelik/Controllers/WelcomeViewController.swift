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
        
//        var param1 = WCLShineParams()
//        param1.bigShineColor = UIColor(rgb: (153,152,38))
//        param1.smallShineColor = UIColor(rgb: (102,102,102))
//        param1.enableFlashing = true
//        param1.animDuration = 3
//        let bt1 = WCLShineButton(frame: .init(x: 100, y: 100, width: 60, height: 60), params: param1)
//        bt1.fillColor = UIColor(rgb: (153,152,38))
//        bt1.color = UIColor(rgb: (170,170,170))
//        bt1.image = WCLShineImage.star
//        bt1.setClicked(!bt1.isSelected, animated: true)
//
//        //bt1.addTarget(self, action: #selector(action), for: .valueChanged)
//        self.view.addSubview(bt1)
        
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
