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
    
    var user: User! = User()
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var signInwithEmailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
        
        var isLoggedIn = false
        
        (isLoggedIn,user!) = LoginManager.checkIfUserLoggedIn()
        
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
        LoginManager.LoginWithFB {
            self.user.getFBUserProfile {
                self.directToWelcomePage()
            }
        }
    }
    
    func directToWelcomePage() {
        performSegue(withIdentifier: "directWelcomeSegue", sender: user)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "directWelcomeSegue" {
            let welcomeVC = segue.destination as! WelcomeViewController
            welcomeVC.user = user
        }
    }
    
    @IBAction func btnEmailLoginClicked(_ sender: Any) {
        //TODO boş girilmesi handle edilecek
        if(user.getEmailUserProfile(email: emailField.text!)) {
            self.directToWelcomePage()
        }
    }
    
    @IBAction func btnGuestLoginClicked(_ sender: Any) {
        user = User(isGuestUser: true)
        self.directToWelcomePage()
    }
}
    


