//
//  Game.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 12.11.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Game {
    var hintCount: Int = 0
    var questionsAnswered: Int = 0
    var correctAnswers: Int = 0
    var wrongAnswers: Int = 0
    var currentScore: Int = 0
    var heartTotal: Int = 0
    var questionSet = [Question]()
    
    static let sharedGame = Game()
    private init() {}
    
    func endCurrentGame() {
        hintCount = 0
    }
    
    func start(completed: @escaping () -> Void) {
        hintCount = hintCountForCurrentGame
        questionsAnswered = 0
        correctAnswers = 0
        wrongAnswers = 0
        currentScore = 0
        heartTotal = User.sharedUser.heartTotal
        Question.getQuestionSet() { (result) in
            self.questionSet = result
            completed()
        }
    }
    
    func end() {
        
    }
}
