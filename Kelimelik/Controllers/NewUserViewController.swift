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
        user.email = emailTextbox.text
        user.username = usernameTextbox.text!
        resultLabel.text = ""

        user.insertUserToDB(user: user) { (result) in
            if((result as? UserInsertResult) != nil) {
                if(result == UserInsertResult.UsernameAlreadyExists) {
                    self.resultLabel.text = "Kullanıcı İsmi Mevcut"
                }
                if(result == UserInsertResult.EmailAlreadyExists) {
                    self.resultLabel.text = "Email mevcut"
                }
                if(result == UserInsertResult.SuccessfullyInserted) {
                    self.directToWelcomePage()
                }
            }
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
