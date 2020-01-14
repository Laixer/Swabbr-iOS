//
//  VlogMakerBaseViewController.swift
//  Swabbr
//
//  Created by James Bal on 04-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import NextLevel
import AVFoundation
import UIKit

class VlogMakerBaseViewController: UIViewController, BaseViewProtocol {
    
    internal let controlView: VlogStreamControlView!
    internal var previewView: UIView!
    
    fileprivate let focusView = FocusIndicatorView(frame: .zero)
    
    private let device = AVCaptureDevice.default(for: .video)
    internal var currentPosition: AVCaptureDevice.Position = .back
    
    private let isStreaming: Bool!
    
    /**
     Initialize this class giving a boolean which determins if it needs a different view.
     - parameter isStreaming: A boolean when true will output more controls for the livestream.
    */
    init(isStreaming: Bool) {
        controlView = VlogStreamControlView(isStreaming: isStreaming)
        self.isStreaming = isStreaming
        super.init(nibName: nil, bundle: nil)
        
        controlView.recordButton.addTarget(self, action: #selector(recordButtonClicked), for: .touchUpInside)
        controlView.flipCameraTopLeftButton.addTarget(self, action: #selector(switchButtonClicked), for: .touchUpInside)
        controlView.flipCameraBottomRightButton.addTarget(self, action: #selector(switchButtonClicked), for: .touchUpInside)
        
        initElements()
        applyConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
            NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
            prepareForVlog()
        } else {
            NextLevel.requestAuthorization(forMediaType: AVMediaType.video) { (mediaType, status) in
                print("NextLevel, authorization updated for media \(mediaType) status \(status)")
                if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
                    NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
                    self.prepareForVlog()
                } else if status == .notAuthorized {
                    NoAudioOrCameraPermissionsAlertDialog.createAlert(context: self, onYesHandler: { (_) in
                        // dismiss
                    })
                    
                }
            }
            NextLevel.requestAuthorization(forMediaType: AVMediaType.audio) { (mediaType, status) in
                print("NextLevel, authorization updated for media \(mediaType) status \(status)")
                if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
                    NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
                    self.prepareForVlog()
                } else if status == .notAuthorized {
                    NoAudioOrCameraPermissionsAlertDialog.createAlert(context: self, onYesHandler: { (_) in
                        // dismiss
                    })
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     This function will handle all the actions required regarding video handling.
    */
    internal func prepareForVlog() {
        fatalError("prepareForVlog() has not been implemented")
    }
    
    internal func initElements() {
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        pinchGesture.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTapGesture(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        
        let screenBounds = UIScreen.main.bounds
        previewView = UIView(frame: screenBounds)
        previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        previewView.addGestureRecognizer(pinchGesture)
        previewView.addGestureRecognizer(tapGesture)
        if !isStreaming {
            NextLevel.shared.previewLayer.frame = previewView.bounds
            previewView.layer.addSublayer(NextLevel.shared.previewLayer)
        }
        view.addSubview(previewView)
        view.addSubview(controlView)
    }
    
    internal func applyConstraints() {
        controlView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            controlView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            controlView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            controlView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            controlView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    /**
     This function will handle the action when the user clicks on the recording button.
    */
    @objc internal func recordButtonClicked() {
        fatalError("recordButtonClicked() has not been implemented")
    }
    
    /**
     This function will handle the action when the user clicks on the "switching camera" button.
    */
    @objc internal func switchButtonClicked() {
        fatalError("switchButtonClicked() has not been implemented")
    }
    
}

// MARK: UIGestureRecognizerDelegate
extension VlogMakerBaseViewController: UIGestureRecognizerDelegate {
    
    /**
     This will handle the "Pinch" gesture. The pinch gesture is responsible for the zooming.
     - parameter pinch: An UIPinchGestureRecognizer object.
     */
    @objc fileprivate func handlePinchGesture(_ pinch: UIPinchGestureRecognizer) {
        
        if currentPosition == .front {
            return
        }
        
        let maxZoomFactor = device?.activeFormat.videoMaxZoomFactor
        
        switch pinch.state {
        case .changed:
            if isStreaming {
                do {
                    try device?.lockForConfiguration()
                    defer {
                        device?.unlockForConfiguration()
                    }
                    let desiredZoom = device!.videoZoomFactor + atan2(pinch.velocity, 5.0)
                    device?.videoZoomFactor = max(1.0, min(desiredZoom, maxZoomFactor!))
                } catch {
                    print(error)
                }
            } else {
                NextLevel.shared.videoZoomFactor *= Float(pinch.scale)
            }
        default:
            break
        }
    }
    
    /**
     This will handle the "Tap" gesture. The tap gesture will create an area where the camera
     will put it's focus.
     - parameter tap: An UITapGestureRecognizer object.
     */
    @objc fileprivate func handleSingleTapGesture(_ tap: UITapGestureRecognizer) {
        
        let tapPoint = tap.location(in: previewView!)
        
        var focusFrame = focusView.frame
        focusFrame.origin.x = CGFloat((tapPoint.x - (focusFrame.size.width * 0.5)).rounded())
        focusFrame.origin.y = CGFloat((tapPoint.y - (focusFrame.size.height * 0.5)).rounded())
        focusView.frame = focusFrame
        
        previewView?.addSubview(focusView)
        focusView.startAnimation()
        
        if isStreaming {
            do {
                try device?.lockForConfiguration()
                defer {
                    device?.unlockForConfiguration()
                }
                device?.focusPointOfInterest = tapPoint
                device?.exposurePointOfInterest = tapPoint
            } catch {
                print(error)
            }
        } else {
            let adjustedPoint = NextLevel.shared.previewLayer.captureDevicePointConverted(fromLayerPoint: tapPoint)
            NextLevel.shared.focusExposeAndAdjustWhiteBalance(atAdjustedPoint: adjustedPoint)
        }
        
    }
    
}
