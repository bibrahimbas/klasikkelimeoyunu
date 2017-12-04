//
//  GameViewController.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 7.11.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import UIKit
import WCLShineButton

class GameViewController: UIViewController, UITextFieldDelegate {
    var timer = Timer()
    var minutes: Int = starterTimerInMinutes
    var seconds: Int = 60
    var timerString: String = ""
    var userAnswer: String = ""
    var counter = 0
    var currentAnswerButtons: [UIButton] = [UIButton]()
    var noMoreAlphabetPressAllowed: Bool = false
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var keyboard: UIView!
    @IBOutlet var alphabetButtonArray: [UIButton]!
    @IBOutlet weak var currentAnswerView: UIView!
    @IBOutlet weak var hintButton: UIButton!
    var currentQuestionIndex = 0
    var currentQuestion = Question()
    var countdownTimer = Timer()
    var countDownSeconds: Int = countDownTimerInSeconds
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        startCountdownTimer()
        initController()
    }
    
    func initAnswerButtons() {
        currentAnswerButtons.forEach {
            $0.backgroundColor = UIColor.white
            $0.setTitle("_", for: .normal)
        }
        
        userAnswer = ""
        counter = 0
    }
    
    func initController() {
        self.alphabetButtonArray.forEach {
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 10
        }
    }
    
    func startCountdownTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(self.updateCountdownTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdownTimer() {
        countdownLabel.text = "\(countDownSeconds)"
        countDownSeconds -= 1
        
        if(countDownSeconds == -1)
        {
            stopTimer(timer: countdownTimer)
            
            Game.sharedGame.start() {
                self.startMainTimer()
                self.countdownLabel.isHidden = true
                self.questionLabel.isHidden = false
                self.keyboard.isHidden = false
                self.hintButton.isHidden = false
                self.timerView.isHidden = false
                self.displayNextQuestion()
            }
        }
    }
    
    func stopTimer(timer: Timer) {
        if timer != nil {
            timer.invalidate()
        }
    }

    func startMainTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(self.updateMainTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateMainTimer() {
        seconds -= 1
        
        if seconds == 0 {
            minutes -= 1
            seconds = 59
        }
        
        let secondsLabel = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
        timerString = "0\(minutes) : \(secondsLabel)"
        timerLabel.text = timerString
        
        if(seconds == 1 && minutes == 0)
        {
            stopTimer(timer: timer)
        }
    }
    
    func getNextQuestion() {
        currentQuestion = (Game.sharedGame.questionSet[currentQuestionIndex] as? Question)!
    }
    func displayNextQuestion() {
        getNextQuestion()
        self.questionLabel.text = currentQuestion.question
        self.currentAnswerButtons.removeAll()
        self.noMoreAlphabetPressAllowed = false
        self.initAnswerButtonArray(currentQuestion.answer.count)
        currentQuestionIndex += 1
    }
    
    func initAnswerButtonArray(_ answerLength: Int) {
        var buttonWidth = 60
        var buttonHeight = 70
        if(answerLength > 6) {
            buttonWidth = 45
            buttonHeight = 55
        }
        if(answerLength > 8) {
            buttonWidth = 35
            buttonHeight = 45
        }
        let screenSize = UIScreen.main.bounds
        let screenWidth = Int(screenSize.width)
        
        var xCordinate = (screenWidth - answerLength * buttonWidth) / 2
        
        for _ in 1...answerLength {
            let button = UIButton(frame: CGRect(x: xCordinate, y: 0, width: buttonWidth, height: buttonHeight))
            button.backgroundColor = UIColor.white
            button.setTitle("_", for: .normal)
            button.setTitleColor(Utilities.UIColorFromRGB(rgbValue: 0xC83A48), for: .normal)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 10
            button.addTarget(self, action: #selector(clearSelectedLetter), for: .touchUpInside)
            
            self.currentAnswerView.addSubview(button)
            currentAnswerButtons.append(button)
            xCordinate += buttonWidth + 2
        }
    }
    
    func cleanButtons() {
        for view in currentAnswerView.subviews{
            view.removeFromSuperview()
        }
    }
    
    fileprivate func checkAnswer() {
        noMoreAlphabetPressAllowed = true
        counter = 0
        
        let mainAnswer = currentQuestion.answer.uppercased()
        
        for button in currentAnswerButtons {
            userAnswer += button.currentTitle!
            button.isEnabled = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            if(self.userAnswer == mainAnswer.uppercased())
            {
                for button in self.currentAnswerButtons {
                    button.backgroundColor = UIColor.yellow
                }
            }
            else {
                for button in self.currentAnswerButtons {
                    let index = mainAnswer.index(mainAnswer.startIndex, offsetBy: self.counter)
                    button.setTitle("\(mainAnswer[index])", for: .normal)
                    button.backgroundColor = UIColor.green
                    self.counter += 1
                }
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.cleanButtons()
            self.displayNextQuestion()
            self.initAnswerButtons()
        })
    }
    
    
    @IBAction func alphabetKeyPressed(_ sender: UIButton) {
        if(!noMoreAlphabetPressAllowed) {
            let letter = getWhichLetterIsPressed(tag: sender.tag)
        
            counter += 1
        
            for button in currentAnswerButtons {
                if(button.currentTitle == "_") {
                    button.setTitle(letter, for: .normal)
                    button.backgroundColor = UIColor.lightGray
                
                    if(counter != currentAnswerButtons.count) {
                        return
                    }
                }
            }
        
            checkAnswer()
        }
    }
    
    @IBAction func clearSelectedLetter(_ sender: UIButton) {
        if(sender.currentTitle != "_") {
            sender.setTitle("_", for: .normal)
            sender.backgroundColor = UIColor.white
            counter -= 1
        }
    }
    
    @IBAction func hintButtonPressed(_ sender: Any) {
        var hintArray: [Int] = [Int]()
        var index = 0
        
        for view in currentAnswerView.subviews{
            if let button = view as? UIButton {
                if(button.currentTitle == "_") {
                    hintArray.append(index)
                }
                index += 1
            }
        }
        
        counter += 1 // bu counter önemli !!! alphabetKeyPressed de counter != currentAnswerButtons.count satırı ile
        // cevabın tamamının yazıldıp yazılmadığı kontorlü yapılıyor
        
        let randomIndex = Int(arc4random_uniform(UInt32(hintArray.count)))
        let mainAnswer = currentQuestion.answer.uppercased()
        
        if(hintArray.count > 0) {
            let answerIndex = mainAnswer.index(mainAnswer.startIndex, offsetBy: hintArray[randomIndex])
            currentAnswerButtons[hintArray[randomIndex]].setTitle("\(mainAnswer[answerIndex])", for: .normal)
            currentAnswerButtons[hintArray[randomIndex]].backgroundColor = UIColor.lightGray
        }
        
        if(Game.sharedGame.hintCount > 0) {
            Game.sharedGame.hintCount -= 1
        } else {
            hintButton.isEnabled = false
        }
        
        if(counter == currentAnswerButtons.count){
            checkAnswer()
        }
    }
    
    
    func getWhichLetterIsPressed(tag: Int) -> String {
        var letter = ""
        
        switch tag {
        case 0:
            letter = "Q"
        case 1:
            letter = "W"
        case 2:
            letter = "E"
        case 3:
            letter = "R"
        case 4:
            letter = "T"
        case 5:
            letter = "Y"
        case 6:
            letter = "U"
        case 7:
            letter = "I"
        case 8:
            letter = "O"
        case 9:
            letter = "P"
        case 10:
            letter = "Ğ"
        case 11:
            letter = "Ü"
        case 12:
            letter = "A"
        case 13:
            letter = "S"
        case 14:
            letter = "D"
        case 15:
            letter = "F"
        case 16:
            letter = "G"
        case 17:
            letter = "H"
        case 18:
            letter = "J"
        case 19:
            letter = "K"
        case 20:
            letter = "L"
        case 21:
            letter = "Ş"
        case 22:
            letter = "İ"
        case 23:
            letter = "Z"
        case 24:
            letter = "X"
        case 25:
            letter = "C"
        case 26:
            letter = "V"
        case 27:
            letter = "B"
        case 28:
            letter = "N"
        case 29:
            letter = "M"
        case 30:
            letter = "Ö"
        case 31:
            letter = "Ç"
        default:
            letter = ""
        }
        return letter
    }
}

