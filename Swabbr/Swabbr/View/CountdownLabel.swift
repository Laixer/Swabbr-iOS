//
//  CountdownLabel.swift
//  Swabbr
//
//  Created by James Bal on 23-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit

class CountdownLabel: UILabel {
    
    private var timer = Timer()
    /// seconds to countdown from, default is 3
    private var seconds: TimeInterval = 3
    
    typealias CompletionHandler = () -> Void
    
    private var completionHandler: CompletionHandler?
    
    /**
     This will initialize the class with the given amount of seconds to countdown from.
     - parameter seconds: The amount of seconds the countdown will take.
    */
    init(seconds: TimeInterval) {
        self.seconds = seconds
        super.init(frame: .zero)
        readyView()
    }
    
    init() {
        super.init(frame: .zero)
        readyView()
    }
    
    /**
     Sets up the view by setting the text of the label to the amount of seconds to start from.
    */
    private func readyView() {
        text = "\(Int(seconds))"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     This function will start the countdown, it will call a Timer that will be run every second.
     - parameter completionHandler: A callback function that will be called when the timer is done
    */
    func startCountdown(completionHandler: @escaping CompletionHandler) {
        self.completionHandler = completionHandler
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
    }
    
    /**
     This function is called by the Timer every seconds.
     It handles the logic by actually updating the label with the new value.
     If the amount of seconds reach 0 the class will stop and invalidate the current timer and will trigger the completionHandler.
    */
    @objc private func updateLabel() {
        if seconds <= 1 {
            timer.invalidate()
            completionHandler!()
        } else {
            seconds -= 1
            text = "\(Int(seconds))"
        }
    }
    
}
