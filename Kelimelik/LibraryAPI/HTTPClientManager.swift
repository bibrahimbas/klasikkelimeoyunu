//
//  HTTPClientManager.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 21.11.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit
import Alamofire.Swift
import SwiftyJSON

final class HTTPClientManager {
    
    func getJson(type: String, completed: @escaping (JSON) -> ()) {
        let apiURL = URL(string: ApiBaseAddress + type)
        
        Alamofire.request(apiURL!, method: .get, parameters: nil).validate().responseJSON { (responseData) in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                completed(swiftyJsonVar)
            }
            else {
                completed(JSON())
            }
        }
    }
    
    func getFBUserProfile(completed: @escaping FBGetProfileCompleted) {
        let parameters = ["fields" : "email, first_name, last_name, picture.type(large)"]
        
        FBSDKGraphRequest(graphPath: "/me", parameters: parameters).start { (connection, result, error) -> Void in
            if error != nil {
                print(error ?? "Facebook bilgileri okunurken Hata Oluştu")
                return
            }
            
            let resultData:[String:AnyObject] = result as! [String : AnyObject]
            
            if let firstName = resultData["first_name"] as? String {
                User.sharedUser.username = firstName
            }
            
            if let lastName = resultData["last_name"] as? String {
                User.sharedUser.username += "\(lastName)"
            }
            
            if let email = resultData["email"] as? String {
                User.sharedUser.email = email
            }
            
            if let picture = resultData["picture"] as? NSDictionary {
                if let data = picture["data"] as? NSDictionary {
                    if let url = data["url"] as? String {
                        User.sharedUser.photoUrl = url
                    }
                }
            }
            
            DataService.sharedInstance.createUser(completed: { (result) in
                if(result == UserInsertResult.SuccessfullyInserted) {
                    User.sharedUser.loginMethod = LoginMethod.Facebook.rawValue
                    completed()
                }
            })
            
            
            
        }
    }
    
    func LoginWithFB(completed: @escaping FBLoginCompleted) {
        var isUserLogedIn: Bool = false
        
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
}


