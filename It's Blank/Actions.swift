//
//  Actions.swift
//  It's Blank
//
//  Created by Jordan Gardner on 6/3/18.
//  Copyright © 2018 jordanthomasg. All rights reserved.
//

import UIKit


protocol ActionDelegate: class {
    func performAction(_ action: Action)
}


/**
 Base class representing possible user actions during gameplay.
 
 Actions are created at load time and view controllers are responsible for
 configuring action gesture recognizers, adding them to a view, and handling
 when actions are performed (see ``ActionDelegate``).
 */
class Action {
    let title: String
    let value: Int
    let numberOfTouchesRequired: Int
    weak var delegate: ActionDelegate?

    fileprivate init(title: String, value: Int, numberOfTouchesRequired: Int) {
        self.title = title
        self.value = value
        self.numberOfTouchesRequired = numberOfTouchesRequired
    }
    
    @objc
    func perform() {
        self.delegate?.performAction(self)
    }
    
    func configureGestureRecognizer(delegate: UIGestureRecognizerDelegate) -> UIGestureRecognizer {
        fatalError("Subclasses must override ``Action.configureGestureRecognizer``")
    }
}


/**
 Action subclass representing possible user tapping actions.
 */
class TapAction: Action {
    let numberOfTapsRequired: Int
    
    fileprivate init(title: String, value: Int, numberOfTouchesRequired: Int, numberOfTapsRequired: Int) {
        self.numberOfTapsRequired = numberOfTapsRequired
        super.init(title: title, value: value, numberOfTouchesRequired: numberOfTouchesRequired)
    }
    
    override func configureGestureRecognizer(delegate: UIGestureRecognizerDelegate) -> UIGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.perform))
        tapGestureRecognizer.delegate = delegate
        tapGestureRecognizer.numberOfTouchesRequired = self.numberOfTouchesRequired
        tapGestureRecognizer.numberOfTapsRequired = self.numberOfTapsRequired
        return tapGestureRecognizer
    }
}


/**
 Action subclass representing possible user swiping actions.
 */
class SwipeAction: Action {
    let direction: UISwipeGestureRecognizerDirection
    
    fileprivate init(title: String, value: Int, numberOfTouchesRequired: Int, direction: UISwipeGestureRecognizerDirection) {
        self.direction = direction
        super.init(title: title, value: value, numberOfTouchesRequired: numberOfTouchesRequired)
    }
    
    override func configureGestureRecognizer(delegate: UIGestureRecognizerDelegate) -> UIGestureRecognizer {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.perform))
        swipeGestureRecognizer.delegate = delegate
        swipeGestureRecognizer.numberOfTouchesRequired = self.numberOfTouchesRequired
        swipeGestureRecognizer.direction = self.direction
        return swipeGestureRecognizer
    }
}


/**
 Actions
 
 The Actions enum is a means of namespacing and defining all possible user
 actions, point values, and gesture recognizers in a concise format.
 
 Gameplay controllers are responsible for configuring the actions for use
 before play.
 */
enum Actions {
    /**
     Actions that use a UITapGestureRecognizer
     */
    static let taps = [
        TapAction(title: "Single Tap", value: 1_000, numberOfTouchesRequired: 1, numberOfTapsRequired: 1),
        TapAction(title: "Double Tap", value: 2_000, numberOfTouchesRequired: 1, numberOfTapsRequired: 2),
        TapAction(title: "Triple Tap", value: 3_000, numberOfTouchesRequired: 1, numberOfTapsRequired: 3),
        TapAction(title: "Quadruple Tap", value: 4_000, numberOfTouchesRequired: 1, numberOfTapsRequired: 4),
        TapAction(title: "Two-Finger Single Tap", value: 2_000, numberOfTouchesRequired: 2, numberOfTapsRequired: 1),
        TapAction(title: "Two-Finger Double Tap", value: 4_000, numberOfTouchesRequired: 2, numberOfTapsRequired: 2),
        TapAction(title: "Two-Finger Triple Tap", value: 6_000, numberOfTouchesRequired: 2, numberOfTapsRequired: 3),
        TapAction(title: "Two-Finger Quadruple Tap", value: 8_000, numberOfTouchesRequired: 2, numberOfTapsRequired: 4),
        TapAction(title: "Three-Finger Single Tap", value: 3_000, numberOfTouchesRequired: 3, numberOfTapsRequired: 1),
        TapAction(title: "Three-Finger Double Tap", value: 6_000, numberOfTouchesRequired: 3, numberOfTapsRequired: 2),
        TapAction(title: "Three-Finger Triple Tap", value: 9_000, numberOfTouchesRequired: 3, numberOfTapsRequired: 3),
        TapAction(title: "Three-Finger Quadruple Tap", value: 12_000, numberOfTouchesRequired: 3, numberOfTapsRequired: 4),
        TapAction(title: "Four-Finger Single Tap", value: 4_000, numberOfTouchesRequired: 4, numberOfTapsRequired: 1),
        TapAction(title: "Four-Finger Double Tap", value: 8_000, numberOfTouchesRequired: 4, numberOfTapsRequired: 2),
        TapAction(title: "Four-Finger Triple Tap", value: 12_000, numberOfTouchesRequired: 4, numberOfTapsRequired: 3),
        TapAction(title: "Four-Finger Quadruple Tap", value: 16_000, numberOfTouchesRequired: 4, numberOfTapsRequired: 4),
    ]
    
    /**
     Actions that use a UITapGestureRecognizer
     */
    static let swipes = [
        SwipeAction(title: "Swipe Up", value: 1_000, numberOfTouchesRequired: 1, direction: .up),
        SwipeAction(title: "Swipe Down", value: 1_000, numberOfTouchesRequired: 1, direction: .down),
        SwipeAction(title: "Swipe Left", value: 1_000, numberOfTouchesRequired: 1, direction: .left),
        SwipeAction(title: "Swipe Right", value: 1_000, numberOfTouchesRequired: 1, direction: .right),
        SwipeAction(title: "Two-Finger Swipe Up", value: 1_000, numberOfTouchesRequired: 2, direction: .up),
        SwipeAction(title: "Two-Finger Swipe Down", value: 1_000, numberOfTouchesRequired: 2, direction: .down),
        SwipeAction(title: "Two-Finger Swipe Left", value: 1_000, numberOfTouchesRequired: 2, direction: .left),
        SwipeAction(title: "Two-Finger Swipe Right", value: 1_000, numberOfTouchesRequired: 2, direction: .right),
        SwipeAction(title: "Three-Finger Swipe Up", value: 1_000, numberOfTouchesRequired: 3, direction: .up),
        SwipeAction(title: "Three-Finger Swipe Down", value: 1_000, numberOfTouchesRequired: 3, direction: .down),
        SwipeAction(title: "Three-Finger Swipe Left", value: 1_000, numberOfTouchesRequired: 3, direction: .left),
        SwipeAction(title: "Three-Finger Swipe Right", value: 1_000, numberOfTouchesRequired: 3, direction: .right),
        SwipeAction(title: "Four-Finger Swipe Up", value: 1_000, numberOfTouchesRequired: 4, direction: .up),
        SwipeAction(title: "Four-Finger Swipe Down", value: 1_000, numberOfTouchesRequired: 4, direction: .down),
        SwipeAction(title: "Four-Finger Swipe Left", value: 1_000, numberOfTouchesRequired: 4, direction: .left),
        SwipeAction(title: "Four-Finger Swipe Right", value: 1_000, numberOfTouchesRequired: 4, direction: .right),
    ]
    
    /**
     All Actions
     */
    static let all = taps as [Action] + swipes as [Action]
}
