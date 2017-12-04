//
//  LoginViewController.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 30.10.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var signInwithEmailButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
        
        var isLoggedIn = false
        
        (isLoggedIn) = LoginService.sharedInstance.checkIfUserLoggedIn()
            if(isLoggedIn) {
            directToWelcomePage()
        }
    }
    
    func dismissKeyboard(userText: UITextField!) -> Bool {
        emailField.resignFirstResponder()
        return true;
    }
    
    func  textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnFacebookLoginClicked(_ sender: Any) {
        LoginService.sharedInstance.UserLogin(loginMethod: .Facebook) { (result) in
            self.directToWelcomePage()
        }
    }
    
    @IBAction func btnGuestLoginClicked(_ sender: Any) {
        LoginService.sharedInstance.UserLogin(loginMethod: .Guest) { (result) in
            if(result == LoginResult.LoginOk) {
                self.directToWelcomePage()
            }
        }
        
    }
    
    func directToWelcomePage() {
        performSegue(withIdentifier: "directWelcomeSegue", sender: User.sharedUser)
    }
    
    @IBAction func btnEmailLoginClicked(_ sender: Any) {
        User.sharedUser.username = emailField.text!
        LoginService.sharedInstance.UserLogin(loginMethod: .Email) { (result) in
            if(result == LoginResult.LoginOk)
            {
                self.directToWelcomePage()
            } else if(result == LoginResult.NoUserFound) {
                self.resultLabel.text = "Kullanıcı bulunamadı"
            }
        }
    }
}
    


