//
//  User.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 31.10.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import UIKit

import Firebase


final class User {
    var userId: String = ""
    var username: String = ""
    var email: String? = ""
    var scoreTotal: Int = 0
    var friends: [User] = []
    var level: Int = Level.Easy.rawValue
    var loginMethod: String = LoginMethod.Guest.rawValue
    var grade: Int = Grade.Kaplumbaga.rawValue
    private var photoImage : UIImage = #imageLiteral(resourceName: "defaultProfileImage")
    private var _photoUrl : String = ""
    var heartTotal: Int = 0
    var insertDate: Date = Date()
    var rankAllTimes: Int = 0
    var rankThisWeek: Int = 0
    var rankToday: Int = 0
    var uuid: String = ""
    
    var photoUrl : String {
        set(url) {
            self._photoUrl = url

            if(url.trimmingCharacters(in: NSCharacterSet.whitespaces) != "") {
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
    
    static let sharedUser = User()
    private init() {}
    
//    init(username: String, email: String, level: Level = Level.Easy, photoUrl: String, loginMethod: String) {
//
//        self.username = username
//        self.email = email
//        self.level = level
//        self.photoUrl = photoUrl
//        self.loginMethod = loginMethod
//    }

    func getEmailUserProfile(childValue: String) -> GetUserFromDBResult {
        var result = GetUserFromDBResult.Unidentified

        return result
    }
    
    func initUser(userData: [String:Any]) {
        
        if let username = userData["username"] as? String {
            self.username = username
        }
        if let email = userData["email"] as? String {
            self.email = email
        }
        if let grade = userData["grade"] as? Int {
            self.grade = grade
        }
        if let heartTotal = userData["heartTotal"] as? Int {
            self.heartTotal = heartTotal
        }
        if let insertDate = userData["insertDate"] as? Date {
            self.insertDate = insertDate
        }
        if let level = userData["level"] as? Int {
            self.level = level
        }
        if let loginMethod = userData["loginMethod"] as? String {
            self.loginMethod = loginMethod
        }
        if let photo = userData["photo"] as? String {
            self.photoUrl = photo
        }
        if let rankAllTimes = userData["rankAllTimes"] as? Int {
            self.rankAllTimes = rankAllTimes
        }
        if let rankThisWeek = userData["rankThisWeek"] as? Int {
            self.rankThisWeek = rankThisWeek
        }
        if let rankToday = userData["rankToday"] as? Int {
            self.rankToday = rankToday
        }
        if let scoreTotal = userData["scoreTotal"] as? Int {
            self.scoreTotal = scoreTotal
        }
        if let userId = userData["userId"] as? String {
            self.userId = userId
        }
        if let uuid = userData["uuid"] as? String {
            self.uuid = uuid
        }
    }
    
    
    func initGuestUser() {
        self.username = GuestUserNamePrefix + Utilities.randomString(length: 5)
        self.grade = Grade.Kaplumbaga.rawValue
        self.heartTotal = HeartTotal
        self.level = Level.Easy.rawValue
        self.loginMethod = LoginMethod.Guest.rawValue
        self.rankAllTimes = 0
        self.rankThisWeek = 0
        self.rankToday = 0
        self.scoreTotal = 0
        self.userId = ""
        self.uuid = UIDevice.current.identifierForVendor!.uuidString
    }
    func toAnyObject() -> Dictionary<String, AnyObject?> {
        
        let userJson: Dictionary<String, AnyObject?> = [
            "email" : self.email,
            "friends" : [],
            "grade" : Grade.Kaplumbaga.rawValue,
            "heartTotal" : HeartTotal,
            "insertDate" : Utilities.getDateWithTime(),
            "level" : Level.Easy.rawValue,
            "loginMethod" : self.loginMethod,
            "photo" : self.photoUrl,
            "rankAllTimes" : 0,
            "rankThisWeek" : 0,
            "rankToday" : 0,
            "scoreTotal" : 0,
            "userId" : 0,
            "username" : self.username,
            "uuid" : self.uuid
            ] as? AnyObject as! Dictionary<String, AnyObject?>
        
        return userJson
        
    }
}
