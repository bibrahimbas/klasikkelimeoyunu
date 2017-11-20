//
//  CurrentGame.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 12.11.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import Foundation

class CurrentGame {
    var hintCount: Int
    var questionsAnswered: Int = 0
    var correctAnswers: Int = 0
    var wrongAnswers: Int = 0
    var score: Int = 0
    var heartTotal: Int = 0
    
    init() {
        hintCount = hintCountForCurrentGame
    }
    
    func endCurrentGame() {
        hintCount = 0
    }
}
