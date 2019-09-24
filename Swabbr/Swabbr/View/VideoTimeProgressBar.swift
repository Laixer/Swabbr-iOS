//
//  VideoTimeProgressBar.swift
//  Swabbr
//
//  Created by Anonymous on 23-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit

class VideoTimeProgressBar : UIProgressView {
    
    /// required time to make this bar fill up, default is 10.0
    private var requiredTimeInSeconds: TimeInterval = 10
    
    typealias CompletionHandler = () -> Void
    
    /// initializers for this progress view
    init() {
        super.init(frame: .zero)
        readyView()
    }
    
    init(requiredTimeInSeconds: TimeInterval) {
        self.requiredTimeInSeconds = requiredTimeInSeconds
        super.init(frame: .zero)
        readyView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// ready up view with general settings
    private func readyView() {
        tintColor = UIColor.red
        backgroundColor = UIColor.gray
    }
    
    func start(completionHandler: @escaping CompletionHandler) {
        
        // start animating
        // TODO: this is kind of a hack, fix later
        UIView.animate(withDuration: 0.0, animations: { () -> Void in
            self.layoutIfNeeded()
        }, completion: { (finished) in
            self.progress = 1
            
            UIView.animate(withDuration: self.requiredTimeInSeconds, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
                self.layoutIfNeeded()
            }, completion: { (completed) in
                completionHandler()
            })
        })
        
    }

    
}
