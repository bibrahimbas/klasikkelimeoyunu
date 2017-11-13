//
//  NewUserViewController.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 12.11.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import UIKit

class NewUserViewController : UIViewController {
    @IBOutlet weak var usernameTextbox: UITextField!
    @IBOutlet weak var emailTextbox: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    var user = User()
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func newUserCreatePressed(_ sender: Any) {
        if(user.isUsernameExist(username: usernameTextbox.text!)) {
            resultLabel.text = "Bu kullanıcı mevcut. Başka bir kullanıcı ismi seçiniz"
            return
        }
        
        if(user.isEmailExist(email: emailTextbox.text!)) {
            resultLabel.text = "Bu email adresi mevcut. Başka bi email adresi ile deneyiniz"
            return
        }
        
        user = User(username: usernameTextbox.text!, email: emailTextbox.text!, level: Level.Easy, photoUrl: "", loginMethod: LoginMethod.NewUser.rawValue )
        
        if(user.createNewUser(user: user)) {
            directToWelcomePage()
        }
    }
    
    func directToWelcomePage() {
        performSegue(withIdentifier: "directWelcomeFromNewLoginSegue", sender: user)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "directWelcomeFromNewLoginSegue" {
            let welcomeVC = segue.destination as! WelcomeViewController
            welcomeVC.user = user
        }
    }
}
