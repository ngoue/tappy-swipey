//
//  BaseGameViewController.swift
//  TappySwipey
//
//  Created by Jordan Gardner on 6/3/18.
//  Copyright © 2018 jordanthomasg. All rights reserved.
//

import UIKit

class BaseGameViewController: UIViewController {
    
    @IBOutlet weak var touchesView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    var loading = true
    var paused = false
    var points = 0
    var pointValuesShouldDecrease = false
    var comboTimer: Timer?
    var comboStack: [PerformedAction] = []
    var shouldResetComboStack = false
    var actionCounters: [String: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureActionsForGameplay()
        self.startComboTimer()
        self.updateTopLabel()
        self.updatePointsLabel()
        self.start()
    }
    
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
            self.touchesView.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    /**
     Called when the controller loads and anytime the pause menu is dismissed.
     Allows subclasses to specify the top label text.
     */
    func updateTopLabel() {
         fatalError("Subclasses must override ``BaseGameViewController.updateTopLabel``")
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
    func addActionToComboStack(_ action: PerformedAction) {
        self.comboStack.append(action)
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
    
    /**
     Start the game
     */
    func start() {
        self.loading = false
    }
    
    /**
     End the game
     */
    func end() {
        self.loading = true
        self.comboTimer?.invalidate()
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     Show a label to the user when an action is performed
     */
    func showActionLabel(text: String, value: Int) {
        // Display the action to the user
        let actionView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-32, height: 80))
        actionView.center = self.view.center
        actionView.tag = 1000
        // Action label
        let actionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: actionView.frame.width, height: actionView.frame.height/2))
        actionLabel.text = text
        // actionLabel.textColor = randomColor()
        actionLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        actionLabel.adjustsFontSizeToFitWidth = true
        actionLabel.minimumScaleFactor = 0.5
        actionLabel.textAlignment = .center
        // Points label
        let pointsLabel = UILabel(frame: CGRect(x: 0, y: actionView.frame.height/2, width: actionView.frame.width, height: actionView.frame.height/2))
        pointsLabel.text = "\(value) pts"
        pointsLabel.adjustsFontSizeToFitWidth = true
        pointsLabel.minimumScaleFactor = 0.5
        pointsLabel.textAlignment = .center
        // Add views
        actionView.addSubview(actionLabel)
        actionView.addSubview(pointsLabel)
        self.view.insertSubview(actionView, belowSubview: self.touchesView)
        // Animate action view
        UIView.animate(
            withDuration: 2.0,
            delay: 0.0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.7,
            options: [],
            animations: {
                var frameRect = actionView.frame
                frameRect.origin.y -= 0.25 * self.view.frame.height
                actionView.frame = frameRect
                actionView.alpha = 0.0
        }) { (complete) in
            actionLabel.removeFromSuperview()
            pointsLabel.removeFromSuperview()
            actionView.removeFromSuperview()
        }
    }
    
    /**
     Handle when a user pauses and unpauses the game
     */
    @IBAction func pauseButtonTapped(_ sender: Any) {
        self.paused ? self.unpause() : self.pause()
    }
    
    /**
     Pause the game
    */
    func pause() {
        self.paused = true
        self.pauseButton.setTitle("play", for: .normal)
        // Remove action labels from view
        for view in self.view.subviews {
            if view.tag == 1000 {
                view.removeFromSuperview()
            }
        }
    }
    
    /**
     Resume the game
     */
    func unpause() {
        self.paused = false
        self.pauseButton.setTitle("pause", for: .normal)
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
        if self.loading || self.paused {
            return
        }
        let performedAction = PerformedAction(action, for: UIDevice.current.orientation)
        self.addActionToComboStack(performedAction)
        if self.checkForCombo() {
            return
        }
        if self.actionCounters[performedAction.description] == nil {
            self.actionCounters[performedAction.description] = 0
        }
        self.actionCounters[performedAction.description]! += 1
        let points = self.pointValuesShouldDecrease ?
            action.value / self.actionCounters[performedAction.description]! :
            action.value
        self.addPoints(points)
        self.showActionLabel(text: performedAction.description, value: points)
    }
}

