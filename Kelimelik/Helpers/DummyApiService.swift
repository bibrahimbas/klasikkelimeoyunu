//
//  DummyApiService.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 2.11.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import UIKit

class DummyApiService: NSObject {

    static func getUserProfileWithEmail(email: String) -> Dictionary<String, AnyObject?>
    {
        let userJson: Dictionary<String, AnyObject?> = [
            "email" : "belma.ibrahimbas@gmail.com",
            "friends" : [
                "QxEGSuf3JNAAwowl3bn" : [
                    "insertDate" : "05112017",
                    "photo" : "https://pbs.twimg.com/profile_images/378800000502463422/a35f00f5ffc1842be68778255318a89e_400x400.jpeg",
                    "scoreTotal" : 1200,
                    "userId" : "KxEGSuf3JNAAwowl3bn",
                    "username" : "emon"
                ]
            ],
            "grade" : "kartal",
            "heartTotal" : 5,
            "insertDate" : "30102017",
            "level" : 2,
            "loginMethod" : 1,
            "photo" : "https://media.licdn.com/media/AAEAAQAAAAAAAA12AAAAJGY3OTMxMzIzLTNhMzYtNGRkMC1iN2M0LTQ5ZThjYjllYzBlMA.jpg",
            "rankAllTimes" : 1,
            "rankThisWeek" : 1,
            "rankToday" : 1,
            "scoreTotal" : 1560,
            "userId" : "KxEGSuf3JNAAwowl3bn",
            "username" : "emon"
            ] as? AnyObject as! Dictionary<String, AnyObject?>
        
        return userJson
    }

    static func getQuestionByLevel(level: Level) -> Dictionary<String, AnyObject?> {
        var questionJson: Dictionary<String, AnyObject?> = [
            "answer" : "Ağaç",
            "level" : 1,
            "question" : "Meyve verebilen, gövdesi odun veya kereste olmaya elverişli bulunan ve uzun yıllar yaşayabilen bitki"
        ] as? AnyObject as! Dictionary<String, AnyObject?>
        
        if(level == Level.Middle) {
            questionJson = ["answer" : "İşaret",
                            "level" : 1,
                            "question" : "El, yüz hareketleriyle gösterme"] as? AnyObject as! Dictionary<String, AnyObject?>
        }
        return questionJson
    }
}
