//
//  BaseGameViewController.swift
//  TappySwipey
//
//  Created by Jordan Gardner on 6/3/18.
//  Copyright © 2018 jordanthomasg. All rights reserved.
//

import UIKit

class BaseGameViewController: UIViewController {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var paused = false
    var points = 0
    var pointValuesShouldDecrease = false
    var comboTimer: Timer?
    var comboStack: [String] = []
    var shouldResetComboStack = false
    var actionCounters: [String: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureActionsForGameplay()
        self.startComboTimer()
        self.updateTopLabel()
        self.updatePointsLabel()
    }
    
    // MARK:- Setup
    
    /**
     Configure all actions and prepare for gameplay
     - Set ``self`` as action delegate
     - Add action gesture recognizers to view
     - Initialize ``actionCounters``
     */
    func configureActionsForGameplay() {
        for action in Actions.all {
            action.delegate = self
            let gestureRecognizer = action.configureGestureRecognizer(delegate: self)
            self.view.addGestureRecognizer(gestureRecognizer)
            self.actionCounters[action.title] = 0
        }
    }
    
    /**
     Called when the controller loads and anytime the pause menu is dismissed.
     Allows subclasses to specify the top label text.
     */
    func updateTopLabel() {
        self.topLabel.text = "[TOP LABEL]"
        // fatalError("Subclasses must override ``BaseGameViewController.updateTopLabel``")
    }
    
    /**
     Update the points label
     */
    func updatePointsLabel() {
        let formattedPoints = NumberFormatter.localizedString(from: self.points as NSNumber, number: .decimal)
        self.bottomLabel.text = "\(formattedPoints) pts"
    }
    
    /**
     Set a timer to clear the combo stack periodically, requiring users to
     perform combos in a timely fasion.
     */
    func startComboTimer() {
        self.comboTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.shouldResetComboStack {
                self.comboStack.removeAll()
            }
            // The combo stack should reset on next fire if no other actions
            // are performed.
            self.shouldResetComboStack = true
        }
    }
    
    /**
     Add points to the total score and update the bottom label.
     */
    func addPoints(_ points: Int) {
        self.points += points
        self.updatePointsLabel()
    }
    
    /**
     Add the given action to the combo stack.
     
     Additionally, set ``shouldResetComboStack`` to ``false`` so the combo
     timer resets.
     */
    func addActionToComboStack(_ action: Action) {
        self.comboStack.append(action.title)
        self.shouldResetComboStack = false
    }
    
    /**
     Check if a combo action has been performed.
     */
    func checkForCombo() -> Bool {
        // TODO: implement
        return false
    }
    
    /**
     Called when a combo action is performed by the user.
     
     Automatically adjusts the combo stack and removes the actions that
     comprise the given combo action.
     */
    func userPerformedCombo(_ combo: Action, actionCount: Int) {
        self.comboStack.removeLast(actionCount)
        self.performAction(combo)
    }
}


// MARK:- UIGestureRecognizerDelegate

extension BaseGameViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Prevent taps from building on each other.  This prevents a double
        // tap from registering as both a single tap followed by a double tap.
        guard let gestureRecognizer = gestureRecognizer as? UITapGestureRecognizer else { return false }
        guard let otherGestureRecognizer = otherGestureRecognizer as? UITapGestureRecognizer else { return false }
        let sameNumberOfTouchesRequired = gestureRecognizer.numberOfTouchesRequired == otherGestureRecognizer.numberOfTouchesRequired
        let fewerNumberOfTapsRequired = gestureRecognizer.numberOfTapsRequired < otherGestureRecognizer.numberOfTapsRequired
        return sameNumberOfTouchesRequired && fewerNumberOfTapsRequired
    }
}


// MARK:- ActionDelegate

extension BaseGameViewController: ActionDelegate {
    /**
     Called when an action is performed by the user.
     */
    func performAction(_ action: Action) {
        print("Perform \(action.title)")
        self.addActionToComboStack(action)
        if self.checkForCombo() {
            return
        }
        self.actionCounters[action.title]! += 1
        let points = self.pointValuesShouldDecrease ?
            action.value / self.actionCounters[action.title]! :
            action.value
        self.addPoints(points)
        // TODO: Show action label to user
    }
}

