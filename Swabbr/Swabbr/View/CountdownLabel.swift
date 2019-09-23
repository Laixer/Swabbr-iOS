//
//  CountdownLabel.swift
//  Swabbr
//
//  Created by Anonymous on 23-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit

class CountdownLabel: UILabel {
    
    private var timer = Timer()
    // seconds to countdown from, default is 3
    private var seconds: TimeInterval = 3
    
    typealias CompletionHandler = () -> Void
    
    private var completionHandler: CompletionHandler?
    
    init(seconds: TimeInterval) {
        self.seconds = seconds
        super.init(frame: .zero)
        readyView()
    }
    
    init() {
        super.init(frame: .zero)
        readyView()
    }
    
    private func readyView() {
        text = "\(Int(seconds))"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startCountdown(completionHandler: @escaping CompletionHandler) {
        self.completionHandler = completionHandler
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
    }
    
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
