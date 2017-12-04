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
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func newUserCreatePressed(_ sender: Any) {
        User.sharedUser.email = emailTextbox.text
        User.sharedUser.username = usernameTextbox.text!
        resultLabel.text = ""

        DataService.sharedInstance.createUser() { (result) in
            if((result as? UserInsertResult) != nil) {
                if(result == UserInsertResult.UsernameAlreadyExists) {
                    self.resultLabel.text = "Kullanıcı İsmi Mevcut"
                }
                if(result == UserInsertResult.EmailAlreadyExists) {
                    self.resultLabel.text = "Email mevcut"
                }
                if(result == UserInsertResult.SuccessfullyInserted) {
                    LoginService.sharedInstance.UserLogin(loginMethod: .Email, completed: { (result) in
                        if(result == LoginResult.LoginOk) {
                            self.directToWelcomePage()
                        }
                        else {
                            //TODO Başarısız login hata !!!
                        }
                    })
                }
            }
        }
    }
    
    func directToWelcomePage() {
        performSegue(withIdentifier: "directWelcomeFromNewLoginSegue", sender: User.sharedUser)

    }
}
