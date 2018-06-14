//
//  TimedGameViewController.swift
//  TappySwipey
//
//  Created by Jordan Gardner on 6/6/18.
//  Copyright © 2018 jordanthomasg. All rights reserved.
//

import UIKit

class TimedGameViewController: BaseGameViewController {

    var gameTimer: Timer?
    var seconds = 60.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pointValuesShouldDecrease = true
    }
    
    override func updateTopLabel() {
        self.topLabel.text = "\(Int(ceil(seconds)))"
    }
    
    override func start() {
        super.start()
        self.startGameTimer()
    }
    
    override func cleanup() {
        super.cleanup()
        self.gameTimer?.invalidate()
    }
    
    /**
     Start the game timer.  Time is tracked in milliseconds for accuracy.
     */
    func startGameTimer() {
        self.gameTimer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { (timer) in
            if self.loading || self.paused {
                return
            }
            self.seconds -= 0.001
            self.updateTopLabel()
            if self.seconds <= 0 {
                self.end()
            }
        }
    }
}
