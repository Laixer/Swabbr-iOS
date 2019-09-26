//
//  VlogStreamControlView.swift
//  Swabbr
//
//  Created by James Bal on 23-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit

class VlogStreamControlView : UIView {
    
    private let minimumVlogTimeProgressBar = VlogTimeProgressBar()
    private let countdownLabel = CountdownLabel()
    
    public let flipCameraBottomRightButton = UIButton(type: UIButton.ButtonType.infoDark)
    public let flipCameraTopLeftButton = UIButton(type: UIButton.ButtonType.infoDark)
    public let recordButton = UIButton(type: UIButton.ButtonType.infoDark)
    
    public let cameraFiltersButton = UIButton(type: UIButton.ButtonType.infoDark)
    
    init() {
        
        super.init(frame: .zero)
        
        tintColor = UIColor.white
        
        countdownLabel.font = countdownLabel.font.withSize(50)
        
        recordButton.isEnabled = false
        
        addSubview(countdownLabel)
        addSubview(minimumVlogTimeProgressBar)
        addSubview(flipCameraTopLeftButton)
        addSubview(flipCameraBottomRightButton)
        addSubview(recordButton)
        
        applyConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     To enure that the constraints are working correctly, we disable the creation of defaults and system constraints to override them with our own.
    */
    private func disableAutoresizing() {
        minimumVlogTimeProgressBar.translatesAutoresizingMaskIntoConstraints = false
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        flipCameraTopLeftButton.translatesAutoresizingMaskIntoConstraints = false
        flipCameraBottomRightButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /**
     This function handles all the constraints for all the views.
     It will apply all the given constraints to the view so it will be displayed accordingly.
    */
    private func applyConstraints() {
        disableAutoresizing()
        
        NSLayoutConstraint.activate([
            
            // countdownLabel
            countdownLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countdownLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // minimumVlogTimeProgressBar
            minimumVlogTimeProgressBar.leftAnchor.constraint(equalTo: leftAnchor),
            minimumVlogTimeProgressBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            minimumVlogTimeProgressBar.heightAnchor.constraint(equalToConstant: 20),
            minimumVlogTimeProgressBar.widthAnchor.constraint(equalToConstant: 300),
            
            // flipCameraTopLeftButton
            flipCameraTopLeftButton.leftAnchor.constraint(equalTo: leftAnchor),
            flipCameraTopLeftButton.topAnchor.constraint(equalTo: topAnchor),
            
            // flipCameraBottomRightButton
            flipCameraBottomRightButton.rightAnchor.constraint(equalTo: rightAnchor),
            flipCameraBottomRightButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            recordButton.bottomAnchor.constraint(equalTo: minimumVlogTimeProgressBar.topAnchor),
            recordButton.centerXAnchor.constraint(equalTo: centerXAnchor)
            
        ])
    }
    
    /**
     This function is part of a large chain which will activate each time when a certain action is done.
     This function is responsible for the countdownLabel to start and handle when it completes.
     - parameter completionHandler: A callback which will be run when the countdown has been finished and thus the camera is fully functional.
    */
    /// start the whole chain of actions required to start a livestream
    func startOperateView(completionHandler: @escaping () -> Void) {
        countdownLabel.startCountdown(completionHandler: {
            self.showCameraView()
            completionHandler()
        })
    }
    
    /**
     This function is responsible to start the VlogTimeProgressBar.
     It will handle accordingly when the progressbar has been recognized as finished.
     It will also remove the countdownLabel from the screen.
    */
    private func showCameraView() {
        self.minimumVlogTimeProgressBar.start {
            self.recordButton.isEnabled = true
        }
        countdownLabel.removeFromSuperview()
    }
    
    /**
     This will make it so the view itself is clickthrough but not the elements on it.
     This is required because of the fact that we are only interested in the items in this view, the view itself should function as a container and not as a seperate item.
    */
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
}
