//
//  VlogTimeProgressBar.swift
//  Swabbr
//
//  Created by James Bal on 23-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit

class VlogTimeProgressBar: UIProgressView {
    
    /// required time to make this bar fill up, default is 10
    private var requiredTimeInSeconds: TimeInterval = 10
    
    typealias CompletionHandler = () -> Void
    
    init() {
        super.init(frame: .zero)
        readyView()
    }
    
    /**
     This will initialize the class with a custom requiredTimeInSeconds value.
     - parameter requiredTimeInSeconds: The required seconds that will be taken as an maximum to draw the progressbar.
    */
    init(requiredTimeInSeconds: TimeInterval) {
        self.requiredTimeInSeconds = requiredTimeInSeconds
        super.init(frame: .zero)
        readyView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Sets up the view, things like background and text color will be initialized here.
    */
    private func readyView() {
        tintColor = UIColor.red
        backgroundColor = UIColor.gray
    }
    
    /**
     This function starts the progressbar.
     It accepts a callback function which will be called one the timer is finished and thus the animation is done.
     - parameter completionHandler: A callback function that will run when the timer is finished and thus the animation is done.
    */
    func start(completionHandler: @escaping CompletionHandler) {
        
        // start animating
        UIView.animate(withDuration: 0.0, animations: { () -> Void in
            self.layoutIfNeeded()
        }, completion: { (_) in
            self.progress = 1
            
            UIView.animate(withDuration: self.requiredTimeInSeconds, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
                self.layoutIfNeeded()
            }, completion: { (_) in
                completionHandler()
            })
        })
        
    }
}
