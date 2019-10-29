//
//  VlogStreamControlView.swift
//  Swabbr
//
//  Created by James Bal on 23-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit

class VlogStreamControlView : UIView {
    
    private var minimumVlogTimeProgressBar: VlogTimeProgressBar?
    private let countdownLabel = CountdownLabel()
    
    public let flipCameraBottomRightButton = UIButton(type: UIButton.ButtonType.infoDark)
    public let flipCameraTopLeftButton = UIButton(type: UIButton.ButtonType.infoDark)
    public let recordButton = UIButton(type: UIButton.ButtonType.infoDark)
    
    private var isStreaming = false
    
    init(isStreaming: Bool) {
        
        super.init(frame: .zero)
        
        tintColor = UIColor.white
        
        self.isStreaming = isStreaming
        
        countdownLabel.font = countdownLabel.font.withSize(50)
        
        recordButton.isEnabled = false
        
        addSubview(countdownLabel)
        addSubview(flipCameraTopLeftButton)
        addSubview(flipCameraBottomRightButton)
        addSubview(recordButton)
        
        if isStreaming {
            minimumVlogTimeProgressBar = VlogTimeProgressBar()
            addSubview(minimumVlogTimeProgressBar!)
        }
        
        applyConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     To enure that the constraints are working correctly, we disable the creation of defaults and system constraints to override them with our own.
    */
    private func disableAutoresizing() {
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        flipCameraTopLeftButton.translatesAutoresizingMaskIntoConstraints = false
        flipCameraBottomRightButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        if isStreaming {
            minimumVlogTimeProgressBar!.translatesAutoresizingMaskIntoConstraints = false
        }
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
            
            // flipCameraTopLeftButton
            flipCameraTopLeftButton.leftAnchor.constraint(equalTo: leftAnchor),
            flipCameraTopLeftButton.topAnchor.constraint(equalTo: topAnchor),
            
            // flipCameraBottomRightButton
            flipCameraBottomRightButton.rightAnchor.constraint(equalTo: rightAnchor),
            flipCameraBottomRightButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            recordButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            recordButton.centerXAnchor.constraint(equalTo: centerXAnchor)
            
        ])
        
        if isStreaming {
            
            NSLayoutConstraint.activate([
                // minimumVlogTimeProgressBar
                minimumVlogTimeProgressBar!.leftAnchor.constraint(equalTo: leftAnchor),
                minimumVlogTimeProgressBar!.bottomAnchor.constraint(equalTo: bottomAnchor),
                minimumVlogTimeProgressBar!.heightAnchor.constraint(equalToConstant: 20),
                minimumVlogTimeProgressBar!.widthAnchor.constraint(equalToConstant: 300),
            ])
            
        }
    }
    
    /**
     This function is part of a large chain which will activate each time when a certain action is done.
     This function is responsible for the countdownLabel to start and handle when it completes.
     - parameter completionHandler: A callback which will be run when the countdown has been finished and thus the camera is fully functional.
    */
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
        if isStreaming {
            self.minimumVlogTimeProgressBar!.start {
                self.recordButton.isEnabled = true
            }
        } else {
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
