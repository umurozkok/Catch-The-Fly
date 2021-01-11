//
//  ViewController.swift
//  Catch The Fly
//
//  Created by UMUR on 1.01.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    @IBOutlet var fly: UIImageView!
    
    var timer = Timer()
    var score = 0
    var highScore = 0
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "Score: \(score)"
        
        let storedHighScore = UserDefaults.standard.object(forKey: "highscore")
        
        if storedHighScore == nil {
            highScore = 0
            highScoreLabel.text = "High Score: \(highScore)"
        }
        
        if let newScore = storedHighScore as? Int {
            highScore = newScore
            highScoreLabel.text = "High Score: \(highScore)"
        }
        
        fly.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        fly.addGestureRecognizer(recognizer)
        
        counter = 15
        timeLabel.text = "Time: " + String(counter)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        
        moveFly()
    }
    
    @objc func moveFly() {
        let maxX = view.frame.maxX - 80
        let maxY = view.frame.maxY - 80
        let xCoord = CGFloat.random(in: 0...maxX)
        let yCoord = CGFloat.random(in: 0...maxY)
        
        UIView.animate(withDuration: 0.1) {
            self.fly.transform = CGAffineTransform(translationX: xCoord, y: yCoord)
        }
    }
    
    @objc func increaseScore() {
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    @objc func countDown() {
        
        counter -= 1
        timeLabel.text = "Time: " + String(counter)
        moveFly()
        
        if counter == 0 {
            timer.invalidate()
            
            if self.score > self.highScore {
                self.highScore = self.score
                highScoreLabel.text = "High Score: \(self.highScore)"
                UserDefaults.standard.set(self.highScore, forKey: "highscore")
            }
            
            let alert = UIAlertController(title: "Time's Up", message: "Play Again?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            
            let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { (UIAlertAction) in
                
                self.score = 0
                self.scoreLabel.text = "Score: \(self.score)"
                self.counter = 10
                self.timeLabel.text = String(self.counter)
                
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
            }
            
            alert.addAction(okButton)
            alert.addAction(replayButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
