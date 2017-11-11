//
//  GameViewController.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 7.11.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITextFieldDelegate {
    var timer = Timer()
    var countdownTimer = Timer()
    var minutes: Int = starterTimerInMinutes
    var seconds: Int = 60
    
    var timerString: String = ""
    
    var countDownSeconds: Int = countDownTimerInSeconds
    
    var question: Question = Question()
    var userAnswer: String = ""
    var counter = 0
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var keyboard: UIView!
    @IBOutlet var alphabetButtonArray: [UIButton]!
    @IBOutlet weak var currentAnswerView: UIView!
    var currentAnswerButtons: [UIButton] = [UIButton]()
    
    @IBOutlet weak var hintButton: UIImageView!
    
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
        
        if(countDownSeconds == -2)
        {
            stopTimer(timer: countdownTimer)
            getQuestionByLevel(level: Level.Easy)
            startMainTimer()
            countdownLabel.isHidden = true
            questionLabel.isHidden = false
            keyboard.isHidden = false
            hintButton.isHidden = false
        }
    }
    
    func startMainTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(self.updateMainTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer(timer: Timer) {
        if timer != nil {
            timer.invalidate()
        }
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
    
    func getQuestionByLevel(level: Level) {
        // TODO kullanıcı level'ı önceki sayfadan alınacak
        question.getQuestionByLevel(level: level)
        questionLabel.text = question.question
        currentAnswerButtons.removeAll()
        initAnswerButtonArray(question.answer.count)
    }
    
    func initAnswerButtonArray(_ answerLength: Int) {
        let buttonWidth = 60
        let buttonHeight = 70
        let screenSize = UIScreen.main.bounds
        let screenWidth = Int(screenSize.width)
        let screenHeight = Int(screenSize.height)
        
        var xCordinate = (screenWidth - answerLength * buttonWidth) / 2
        
        for _ in 1...answerLength {
            let button = UIButton(frame: CGRect(x: xCordinate, y: 8, width: buttonWidth, height: buttonHeight))
            button.backgroundColor = UIColor.white
            button.setTitle("_", for: .normal)
            button.setTitleColor(Utilities.UIColorFromRGB(rgbValue: 0xC83A48), for: .normal)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 10
            
            self.currentAnswerView.addSubview(button)
            currentAnswerButtons.append(button)
            xCordinate += 62
        }
    }
    
    @IBAction func alphabetKeyPressed(_ sender: UIButton) {
        let letter = getWhichLetterIsPressed(tag: sender.tag)
        let mainAnswer = question.answer.uppercased()
        
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
        
        counter = 0
        
        for button in currentAnswerButtons {
            userAnswer += button.currentTitle!
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
            self.getQuestionByLevel(level: Level.Middle)
            self.initAnswerButtons()
        })
    }
    
    @IBAction func clearSelectedLetter(_ sender: UIButton) {
        if(sender.currentTitle != "_") {
            sender.setTitle("_", for: .normal)
            sender.backgroundColor = UIColor.white
            counter -= 1
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

