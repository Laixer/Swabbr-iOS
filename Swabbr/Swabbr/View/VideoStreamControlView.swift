//
//  VideoStreamControlView.swift
//  Swabbr
//
//  Created by Anonymous on 23-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit

class VideoStreamControlView : UIView {
    
    private let minimumVideoTimeProgressBar = VideoTimeProgressBar()
    private let countdownLabel = CountdownLabel()
    
    public let flipCameraBottomRightButton = UIButton(type: UIButton.ButtonType.infoDark)
    public let flipCameraTopLeftButton = UIButton(type: UIButton.ButtonType.infoDark)
    public let recordButton = UIButton(type: UIButton.ButtonType.infoDark)
    
    public let cameraFiltersButton = UIButton(type: UIButton.ButtonType.infoDark)
    
    init() {
        
        super.init(frame: .zero)
        
        tintColor = UIColor.black
        
        countdownLabel.font = countdownLabel.font.withSize(50)
        
        recordButton.isEnabled = false
        
        addSubview(countdownLabel)
        addSubview(minimumVideoTimeProgressBar)
        addSubview(flipCameraTopLeftButton)
        addSubview(flipCameraBottomRightButton)
        addSubview(recordButton)
        
        applyConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// disable automatic constriants so that we can overwrite with our own constraints
    private func disableAutoresizing() {
        minimumVideoTimeProgressBar.translatesAutoresizingMaskIntoConstraints = false
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        flipCameraTopLeftButton.translatesAutoresizingMaskIntoConstraints = false
        flipCameraBottomRightButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// apply the given constraints
    private func applyConstraints() {
        disableAutoresizing()
        
        NSLayoutConstraint.activate([
            
            // countdownLabel
            countdownLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countdownLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // minimumVideoTimeProgressBar
            minimumVideoTimeProgressBar.leftAnchor.constraint(equalTo: leftAnchor),
            minimumVideoTimeProgressBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            minimumVideoTimeProgressBar.heightAnchor.constraint(equalToConstant: 20),
            minimumVideoTimeProgressBar.widthAnchor.constraint(equalToConstant: 300),
            
            // flipCameraTopLeftButton
            flipCameraTopLeftButton.leftAnchor.constraint(equalTo: leftAnchor),
            flipCameraTopLeftButton.topAnchor.constraint(equalTo: topAnchor),
            
            // flipCameraBottomRightButton
            flipCameraBottomRightButton.rightAnchor.constraint(equalTo: rightAnchor),
            flipCameraBottomRightButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            recordButton.bottomAnchor.constraint(equalTo: minimumVideoTimeProgressBar.topAnchor),
            recordButton.centerXAnchor.constraint(equalTo: centerXAnchor)
            
        ])
    }
    
    /// start the whole chain of actions required to start a livestream
    func startOperateView(completionHandler: @escaping () -> Void) {
        countdownLabel.startCountdown(completionHandler: {
            self.showCameraView()
            completionHandler()
        })
    }
    
    /// make the camera functionalities available
    private func showCameraView() {
        self.minimumVideoTimeProgressBar.start {
            self.recordButton.isEnabled = true
        }
        countdownLabel.removeFromSuperview()
    }
    
    /// make the whole view clickable except the items which need to be clickable
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
}
