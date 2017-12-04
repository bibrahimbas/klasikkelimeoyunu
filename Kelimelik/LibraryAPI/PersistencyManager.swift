//
//  PersistencyManager.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 21.11.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import Foundation
import Firebase

final class PersistencyManager {
    
    func setUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set("1", forKey: UserDefaultKeys.DefaultsSetted.rawValue)
        defaults.set(User.sharedUser.loginMethod, forKey: UserDefaultKeys.LoginMethod.rawValue)
        defaults.set(User.sharedUser.username, forKey: UserDefaultKeys.Username.rawValue)
        defaults.set(User.sharedUser.email, forKey: UserDefaultKeys.Email.rawValue)
        defaults.set(User.sharedUser.photoUrl, forKey: UserDefaultKeys.PhotoUrl.rawValue)
    }
    
    func getUserDefaults() {
        if (UserDefaults.standard.value(forKey: UserDefaultKeys.DefaultsSetted.rawValue) as? String) != nil {
            User.sharedUser.username = UserDefaults.standard.string(forKey: UserDefaultKeys.Username.rawValue)!
            User.sharedUser.email = UserDefaults.standard.string(forKey: UserDefaultKeys.Email.rawValue)
            User.sharedUser.loginMethod = (UserDefaults.standard.value(forKey: UserDefaultKeys.LoginMethod.rawValue) as? String)!
            User.sharedUser.photoUrl = UserDefaults.standard.string(forKey: UserDefaultKeys.PhotoUrl.rawValue)!
        }
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
    
    func insertUserToDB(_ completed: @escaping (UserInsertResult) -> Void) {
        var insertResult = UserInsertResult.Unidentified
        
        let ref = Database.database().reference().child("users")
        do {
            ref.child(User.sharedUser.username).setValue(User.sharedUser.toAnyObject(), withCompletionBlock: { (error, ref) in
                insertResult = UserInsertResult.SuccessfullyInserted
                completed(insertResult)
            })
        } catch {
            //TODO handle error
        }
    }
    
    func updateUserProfileToDB(username: String, email: String, photoUrl: String, completed: @escaping (UserUpdateResult) -> Void) {
        var updateResult = UserUpdateResult.Unidentified
        
        let ref = Database.database().reference().child("users").child(User.sharedUser.username)
        do{
            
            ref.updateChildValues(["username": username,
                                  "email": email,
                                  "photo": photoUrl])
            updateResult = UserUpdateResult.SuccessfullyUpdated
            completed(updateResult)
        } catch {
            
        }
    }
    func checkIfUsernameExists(username: String, _ completed: @escaping (UserInsertResult) -> Void) {
        getUserFromDB(childName: "username", childValue: username) { (success, response, error) in
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
    
    func checkIfEmailExist(email: String, _ completed: @escaping (UserInsertResult) -> Void) {
        getUserFromDB(childName: "email", childValue: email) { (success, response, error) in
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
    
    func getUserProfileFromDB(childValue: String, completed: @escaping ([String:Any], GetUserFromDBResult) -> Void) {
        getUserFromDB(childName: "username", childValue: childValue) { (success, response, error) in
            if(success) {
                if let dbResponse = response as? [String:Any] {
                    if(dbResponse.count > 0) {
                        completed(dbResponse, GetUserFromDBResult.UserFound)
                    } else {
                        self.getUserFromDB(childName: "email", childValue: childValue) { (success, response, error) in
                            if(success) {
                                if let dbResponse = response as? [String:Any] {
                                    if(dbResponse.count > 0) {
                                        completed(dbResponse, GetUserFromDBResult.UserFound)
                                    } else {
                                        print("*******succesfully completed [:]")
                                        completed([:], GetUserFromDBResult.NoUserFound)
                                    }
                                } //TODO hanle nil
                            }
                        }
                    }
            } else {
                completed([:], GetUserFromDBResult.NoUserFound)
            }
        }
    }
    }
}
