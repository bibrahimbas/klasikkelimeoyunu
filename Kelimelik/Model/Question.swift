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
    var isAnsweredCorrect = false
    
    static func getQuestionSet(completed: @escaping ([Question]) -> ()) {
        var questionSet = [Question]()
        var question = Question()
        
        if(isWebApiAvailable) {
            
            HTTPClientAPI.sharedInstance.callApi(type: "question") { (result) in
                    for (index, item) in result.arrayValue.enumerated() {
                        question = Question()
                        question.question = item["definition"].rawString()!
                        question.answer = item["word"].rawString()!
                        question.isAnsweredCorrect = false
                        questionSet.insert(question, at: index)
                    }
                completed(questionSet)
            }
        }
    }
}
