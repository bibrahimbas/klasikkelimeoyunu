//
//  LoginManager.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 30.10.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class LoginManager: NSObject {
    static var isUserLogedIn: Bool = false
    
    //TODO: Login bilgisi database de saklanacak ! Oda oluştururken request sonrası eşleştirme yapılırken kullanıcıların logon durumları kontrol edilecek.
    
    static func checkIfUserLoggedIn() -> (isLoggedIn: Bool, user: User) {
        var isLoggedIn = false
        var user: User! = User()
        
        user = user.getUserDefaults() //Default user bilgileri alınır.
        
        if let loginMethod = user.loginMethod as? String {
            if loginMethod != LoginMethod.Guest.rawValue {
                isLoggedIn = true
            }
        }
        
        return (isLoggedIn, user)
    }

    static func LoginWithFB(completed: @escaping FBLoginCompleted) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email", "public_profile"]) { (result, error) in
            if error != nil {
                // TODO: Facebook login HATA
                print("Facebook ile giriş yapılamadı")
            } else if result?.isCancelled == true {
                print("Kullanıcı face girişini iptal etti.")
            }
            else {
                _ = FBSDKAccessToken.current().tokenString
                isUserLogedIn = true
            }
            completed()
        }
    }

    static func LoginWithEmail(email: String) -> Bool {
        
        //TODO User bilgileri REST servisten alınacak
        return isUserLogedIn
    }
}
