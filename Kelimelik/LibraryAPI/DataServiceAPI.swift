//
//  DataServiceAPI.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 21.11.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import Foundation

final class DataService {
    private let persistancyManager = PersistencyManager()
    static let sharedInstance = DataService()
    private init() {}
    
    func setUserDefaults() {
        persistancyManager.setUserDefaults()
    }
    
    func getUserDefaults() {
        persistancyManager.getUserDefaults()
    }
    
    func getUser(childName: String, childValue: String) {
        persistancyManager.getUserFromDB(childName: childName, childValue: childValue) { (success, result, error) in
            
        }
    }
    
    func updateUserProfile(username: String, email: String, photoUrl: String, completed: @escaping (UserUpdateResult) -> Void) {
        var updateResult: UserUpdateResult = .Unidentified
        
        if(username != User.sharedUser.username) {
            checkIfUsernameExists(username: username) { (result) in
                if(result == UserInsertResult.UsernameAlreadyExists) {
                    updateResult = UserUpdateResult.UsernameAlreadyExists
                    completed(updateResult)
                } else {
                    if(email != User.sharedUser.email) {
                        self.checkIfEmailExist(email: email) { (result) in
                            if(result == UserInsertResult.EmailAlreadyExists) {
                                updateResult = UserUpdateResult.EmailAlreadyExists
                                completed(updateResult)
                            }
                        }
                    } else {
                        self.persistancyManager.updateUserProfileToDB(username: username, email: email, photoUrl: photoUrl) { (result) in
                            updateResult = result
                            completed(updateResult)
                        }
                    }
                }
            }
        } else {
            if(email != User.sharedUser.email) {
                checkIfEmailExist(email: email) { (result) in
                    if(result == UserInsertResult.EmailAlreadyExists) {
                            updateResult = UserUpdateResult.EmailAlreadyExists
                            completed(updateResult)
                    } else {
                        self.persistancyManager.updateUserProfileToDB(username: username, email: email, photoUrl: photoUrl) { (result) in
                            updateResult = result
                            completed(updateResult)
                        }
                    }
                }
            } else {
                persistancyManager.updateUserProfileToDB(username: username, email: email, photoUrl: photoUrl) { (result) in
                    updateResult = result
                    completed(updateResult)
                }
            }
        }
    }
    
    func createUser(completed: @escaping (UserInsertResult) -> Void)  {
        //TODO username ve email check ederken case sensitive konusuna bak..
        var insertResult: UserInsertResult = .Unidentified
        checkIfUsernameExists(username: User.sharedUser.username) { (insertResult) in
            if(insertResult == UserInsertResult.UsernameAlreadyExists) {
                completed(insertResult)
            } else {
                self.checkIfEmailExist(email: User.sharedUser.email!) { (insertResult) in
                    if(insertResult == UserInsertResult.EmailAlreadyExists) {
                        completed(insertResult)
                    } else {
                        self.persistancyManager.insertUserToDB() { (insertResult) in
                            completed(insertResult)
                            }
                        }
                    }
                }
            }
        }

    
    func checkIfUsernameExists(username: String, _ completed: @escaping (UserInsertResult) -> Void) {
        persistancyManager.checkIfUsernameExists(username: username) { (result) in
            completed(result)
        }
    }
    
    func checkIfEmailExist(email: String, _ completed: @escaping (UserInsertResult) -> Void) {
        persistancyManager.checkIfEmailExist(email: email) { (result) in
            completed(result)
        }
    }
    
    func getUserProfile(loginValue: String) -> [String:Any] {
        var userData = [String:Any]()
        
        persistancyManager.getUserProfileFromDB(childValue: loginValue) { (response, userFound) in
            if(userFound == GetUserFromDBResult.UserFound) {
                if let dbResponse = response as? [String:Any] {
                    userData = dbResponse
                }
            }
        }
        return userData
    }
}
