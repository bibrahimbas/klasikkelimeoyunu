//
//  Question.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 7.11.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import Foundation

class Question {
    var question: String = ""
    var answer: String = ""
    var level: Level = .Easy
    
    func getQuestionByLevel(level: Level) {
        if(isWebApiAvailable) {
            //TODO Question JSON objesi rest servisinden alınacak
        } else {
            if let questionObject = DummyApiService.getQuestionByLevel(level: level) as? Dictionary<String, AnyObject> {
                
                if let question = questionObject["question"] as? String {
                    self.question = question
                }
                
                if let answer = questionObject["answer"] as? String {
                    self.answer = answer
                }
                
                if let level = questionObject["level"] as? Int {
                    switch level {
                    case 1:
                        self.level = .Easy
                    case 2:
                        self.level = .Middle
                    case 3:
                        self.level = .Hard
                    case 4:
                        self.level = .VeryHard
                    default:
                        self.level = .Easy
                    }
                }
            }
        }
    }
}
