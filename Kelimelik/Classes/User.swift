//
//  User.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 31.10.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase


class User: NSObject {
    var userId: String = ""
    var username: String = ""
    var email: String? = ""
    var totalScore: Int = 0
    var friends: [User] = []
    var level: Level = Level.Easy
    var loginMethod: String = LoginMethod.Guest.rawValue
    var grade: Grade = .Kaplumbaga
    private var photoImage : UIImage = #imageLiteral(resourceName: "defaultProfileImage")
    private var _photoUrl : String = ""
    
    var photoUrl : String {
        set(url) {
            self._photoUrl = url

            if(url != "") {
            let data = try? Data(contentsOf: URL(string: url)!)
                self.photoImage = UIImage(data: data!)! }
        }
        get {
            return _photoUrl
        }
    }
    
    var photo : UIImage {
        return photoImage
    }
    
    override init() {
        super.init()
    }
    
    init(username: String, email: String, level: Level = Level.Easy, photoUrl: String, loginMethod: String) {
        super.init()
        
        self.username = username
        self.email = email
        self.level = level
        self.photoUrl = photoUrl
        self.loginMethod = loginMethod
        
        
    }
    
    init(isGuestUser: Bool) {
        super.init()
        
        self.username = GuestUserNamePrefix + Utilities.randomString(length: 5)

    }
    
    func setUserDefaults(user: User) {
        let defaults = UserDefaults.standard
        
        defaults.set("1", forKey: UserDefaultKeys.DefaultsSetted.rawValue)
        defaults.set(user.loginMethod, forKey: UserDefaultKeys.LoginMethod.rawValue)
        defaults.set(user.username, forKey: UserDefaultKeys.Username.rawValue)
        defaults.set(user.email, forKey: UserDefaultKeys.Email.rawValue)
        defaults.set(user.photoUrl, forKey: UserDefaultKeys.PhotoUrl.rawValue)
    }

    func getUserDefaults() -> User {
        
        let user: User = User()
        
        if (UserDefaults.standard.value(forKey: UserDefaultKeys.DefaultsSetted.rawValue) as? String) != nil {
            user.username = UserDefaults.standard.string(forKey: UserDefaultKeys.Username.rawValue)!
            user.email = UserDefaults.standard.string(forKey: UserDefaultKeys.Email.rawValue)
            user.loginMethod = (UserDefaults.standard.value(forKey: UserDefaultKeys.LoginMethod.rawValue) as? String)!
            user.photoUrl = UserDefaults.standard.string(forKey: UserDefaultKeys.PhotoUrl.rawValue)!
        }
        
        return user
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
                self.username = firstName
            }
            
            if let lastName = resultData["last_name"] as? String {
                self.username += " \(lastName)"
            }
            
            if let email = resultData["email"] as? String {
                self.email = email
            }
            
            if let picture = resultData["picture"] as? NSDictionary {
                if let data = picture["data"] as? NSDictionary {
                    if let url = data["url"] as? String {
                        self.photoUrl = url
                    }
                }
            }
            
            self.level = Level.Easy
            self.loginMethod = LoginMethod.Facebook.rawValue
            LoginManager.isUserLogedIn = true
            
            completed()
        }
    }
    
    func getEmailUserProfile(email: String) -> Bool {
        if(isWebApiAvailable) {
            //TODO User JSON objesi rest servisinden alınacak
        } else {
            if let userJSON = DummyApiService.getUserProfileWithEmail(email: email) as? Dictionary<String, AnyObject> {
                
                if let username = userJSON["username"] as? String {
                    self.username = username
                }
                
                if let photoUrl = userJSON["photo"] as? String {
                    self.photoUrl = photoUrl
                }
                
                self.email = email
                
            }
        }
        
        //TODO isUserLogedIn == false olması handle edilecek
        LoginManager.isUserLogedIn = true
        return LoginManager.isUserLogedIn
    }
    
    func createNewUser(user: User) -> Bool {
        if(isWebApiAvailable) {
            //TODO User JSON objesi rest servis ile kayıt edilecek
        }
        else {
            
        }
        return true
    }
    
    func isUsernameExist(username: String) -> Bool {
        var result = false
        let ref = Database.database().reference().child("users")
        let queryRef = ref.queryOrdered(byChild: "username").queryEqual(toValue: username)
        
        queryRef.observe(.value, with: { snapshot in
            if let user = snapshot.value as? [String:Any] {
                print(user)
                let username = user["username"] as? String
                
                print("**********USERNAME\(username)") //check the value of wins is correct
                result = true
            }
            else {
                print("***************NO USER FOUND")
                result = false
            }
        })
        return result
    }
    
    func isEmailExist(email: String) -> Bool {
        let ref = Database.database().reference().child("users")
        let queryRef = ref.queryOrdered(byChild: "email").queryEqual(toValue: email)
        return true
    }
}
