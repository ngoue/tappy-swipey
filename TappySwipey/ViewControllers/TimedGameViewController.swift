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
    var millisecondsLeft = 60_000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pointValuesShouldDecrease = true
    }
    
    override func updateTopLabel() {
        self.topLabel.text = "\(Int(Double(self.millisecondsLeft)/1000.0))"
    }
    
    override func start() {
        super.start()
        self.gameTimer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { (timer) in
            if self.loading {
                return
            }
            self.millisecondsLeft -= 1
            self.updateTopLabel()
            if self.millisecondsLeft <= 0 {
                self.end()
            }
        }
    }
    
    override func end() {
        self.loading = true
        // TODO: move comboTimer to base controller??
        self.comboTimer?.invalidate()
        self.gameTimer?.invalidate()
    }
}
