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
    
    func getUserFromDB(childName: String, childValue: String, completed: @escaping (Bool, [String:Any], Error?) -> Void) {
        var userData = [String:Any]()
        let ref = Database.database().reference().child("users")
        let queryRef = ref.queryOrdered(byChild: childName).queryEqual(toValue: childValue)
        
        queryRef.observe(.value, with: { snapshot in
            if let user = snapshot.value as? [String:Any] {
                for (_, value) in user {
                    if let userDetails = value as? [String:Any] {
                        userData = (userDetails)
                    }
                }
            }
            completed(true, userData, nil)
        })
    }
    
    fileprivate func checkIfUsernameExists(_ user: User, _ completed: @escaping (UserInsertResult) -> Void) {
        getUserFromDB(childName: "username", childValue: user.username) { (success, response, error) in
            var insertResult = UserInsertResult.Unidentified
            if(success) {
                if let dbResponse = response as? [String:Any] {
                    if(dbResponse.count > 0) {
                        insertResult = UserInsertResult.UsernameAlreadyExists
                    }
                }
            }
            
            completed(insertResult)
        }
    }
    
    fileprivate func checkIfEmailExist(_ user: User, _ completed: @escaping (UserInsertResult) -> Void) {
        getUserFromDB(childName: "email", childValue: user.email!) { (success, response, error) in
            var insertResult = UserInsertResult.Unidentified
            if(success) {
                if let dbResponse = response as? [String:Any] {
                    if(dbResponse.count > 0) {
                        insertResult = UserInsertResult.EmailAlreadyExists
                    }
                }
            }
            
            completed(insertResult)
        }
    }
    
    fileprivate func insertUser(_ user: User, _ completed: @escaping (UserInsertResult) -> Void) {
        var insertResult = UserInsertResult.Unidentified
        
        let ref = Database.database().reference().child("users")
        do {
            ref.childByAutoId().setValue(user.toAnyObject(), withCompletionBlock: { (error, ref) in
               insertResult = UserInsertResult.SuccessfullyInserted
                completed(insertResult)
            })
        } catch {
            //TODO handle error
        }
    }
    
    func insertUserToDB(user:User, completed: @escaping (UserInsertResult) -> Void)  {
        //TODO username ve email check ederken case sensitive konusuna bak..
        var insertResult: UserInsertResult = .Unidentified
        checkIfUsernameExists(user) { (insertResult) in
            if(insertResult == UserInsertResult.UsernameAlreadyExists) {
                completed(insertResult)
            } else {
                self.checkIfEmailExist(user) { (insertResult) in
                    if(insertResult == UserInsertResult.EmailAlreadyExists) {
                        completed(insertResult)
                    } else {
                        self.insertUser(user) { (insertResult) in
                            completed(insertResult)
                        }
                    }
                }
            }
        }
    }
    
    func toAnyObject() -> Dictionary<String, AnyObject?> {
        
        let userJson: Dictionary<String, AnyObject?> = [
            "email" : self.email,
            "friends" : [],
            "grade" : Grade.Kaplumbaga.rawValue,
            "heartTotal" : HeartTotal,
            "insertDate" : Utilities.getDateWithTime(),
            "level" : Level.Easy.rawValue,
            "loginMethod" : LoginMethod.NewUser.rawValue,
            "photo" : self.photoUrl,
            "rankAllTimes" : 0,
            "rankThisWeek" : 0,
            "rankToday" : 0,
            "scoreTotal" : 0,
            "userId" : 0,
            "username" : self.username
            ] as? AnyObject as! Dictionary<String, AnyObject?>
        
        return userJson
        
    }
}
