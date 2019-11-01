//
//  VlogPageViewController.swift
//  Swabbr
//
//  Created by James Bal on 17-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
//  This class will handle all Streaming related actions
//

import UIKit
import CoreMedia
import AVFoundation
import Photos
import HaishinKit
import VideoToolbox
import NextLevel

class VlogStreamViewController : UIViewController, BaseViewProtocol {
    
    
    private var previewView: GLHKView!
    
    private let controlView = VlogStreamControlView(isStreaming: true)
    
    fileprivate var beginZoomScale: Float = 1.0
    fileprivate var focusView = FocusIndicatorView(frame: .zero)
    
    private let maxRetry = 5
    private var retryCount = 0
    
    private var currentPosition: AVCaptureDevice.Position = .back
    
    let rtmpConnection = RTMPConnection()
    var rtmpStream: RTMPStream!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        rtmpStream = RTMPStream(connection: rtmpConnection)
        
        rtmpStream.captureSettings = [
            .sessionPreset: AVCaptureSession.Preset.hd1920x1080,
            .continuousAutofocus: true,
            .continuousExposure: true,
            .fps: 30
        ]
        
        rtmpStream.videoSettings = [
            .width: 720,
            .height: 1280,
            .bitrate: 1000 * 1024,
            .maxKeyFrameIntervalDuration: 0.0,
            .profileLevel: kVTProfileLevel_H264_Baseline_AutoLevel
        ]
        
        rtmpStream.audioSettings = [
            .bitrate: 32 * 1024,
            .sampleRate: 44_100
        ]
        
        rtmpStream.recorderSettings = [
            AVMediaType.audio: [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 0,
                AVNumberOfChannelsKey: 0,
                AVEncoderBitRateKey: 128000,
            ],
            AVMediaType.video: [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoHeightKey: 0,
                AVVideoWidthKey: 0,
            ],
        ]
        
        rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
        rtmpConnection.addEventListener(.ioError, selector: #selector(ioErrorHandler), observer: self)
        
        initElements()
        applyConstraints()
        
        controlView.startOperateView {
            self.rtmpConnection.connect(self.streamUrl, arguments: nil)
        }

        controlView.recordButton.addTarget(self, action: #selector(recordButtonClicked), for: .touchUpInside)
        controlView.flipCameraTopLeftButton.addTarget(self, action: #selector(switchButtonClicked), for: .touchUpInside)
        controlView.flipCameraBottomRightButton.addTarget(self, action: #selector(switchButtonClicked), for: .touchUpInside)
        
    }
    
    @objc func rtmpStatusHandler(_ notification: Notification) {
        let e = Event.from(notification)
        guard let data: ASObject = e.data as? ASObject, let code: String = data["code"] as? String else {
            return
        }
        switch code {
        case RTMPConnection.Code.connectSuccess.rawValue:
            retryCount = 0
            rtmpStream.publish("default")
            break
        case RTMPConnection.Code.connectFailed.rawValue, RTMPConnection.Code.connectClosed.rawValue:
            guard retryCount < maxRetry else {
                return
            }
            
            Thread.sleep(forTimeInterval: pow(2.0, Double(retryCount)))
            rtmpConnection.connect(streamUrl, arguments: nil)
            retryCount += 1
            break
        default:
            break
        }
    }
    
    @objc func ioErrorHandler(_ notification: Notification) {
        DispatchQueue.main.async {
            self.rtmpConnection.connect(self.streamUrl, arguments: nil)
        }
    }
    
    internal func initElements() {
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        pinchGesture.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTapGesture(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        
        let screenBounds = UIScreen.main.bounds
        previewView = GLHKView(frame: screenBounds)
        previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        previewView.addGestureRecognizer(pinchGesture)
        previewView.addGestureRecognizer(tapGesture)
        previewView.videoGravity = .resizeAspectFill
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
    
    @objc func recordButtonClicked() {
        stopStream()
    }
    
    @objc func switchButtonClicked() {
        let position: AVCaptureDevice.Position = currentPosition == .back ? .front : .back
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: position)) { error in
            print(error)
        }
        currentPosition = position
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
            NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
            prepareStream()
        } else {
            NextLevel.requestAuthorization(forMediaType: AVMediaType.video) { (mediaType, status) in
                print("NextLevel, authorization updated for media \(mediaType) status \(status)")
                if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
                    NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
                    self.prepareStream()
                } else if status == .notAuthorized {
                    // gracefully handle when audio/video is not authorized
                    print("NextLevel doesn't have authorization for audio or video")
                }
            }
            NextLevel.requestAuthorization(forMediaType: AVMediaType.audio) { (mediaType, status) in
                print("NextLevel, authorization updated for media \(mediaType) status \(status)")
                if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
                    NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
                    self.prepareStream()
                } else if status == .notAuthorized {
                    // gracefully handle when audio/video is not authorized
                    print("NextLevel doesn't have authorization for audio or video")
                }
            }
        }
    }
    
    private func prepareStream() {
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setPreferredSampleRate(44_100)
            
            if #available(iOS 10.0, *) {
                try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            } else {
                session.perform(NSSelectorFromString("setCategory:withOptions:error:"), with: AVAudioSession.Category.playAndRecord, with:  [AVAudioSession.CategoryOptions.allowBluetooth])
            }
            try session.setActive(true)
        } catch {
        }
        
        rtmpStream.attachAudio(AVCaptureDevice.default(for: .audio)) { error in
            print("Error with audio")
        }
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: currentPosition)) { error in
            print("Error with camera")
        }
        
        self.previewView.attachStream(self.rtmpStream)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func stopStream() {
        rtmpStream.close()
        rtmpStream.dispose()
    }
    
}

// MARK: UIGestureRecognizerDelegate
extension VlogStreamViewController : UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPinchGestureRecognizer.self) {
            beginZoomScale = Float(rtmpStream.zoomFactor)
        }
        return true
    }
    
    /**
     This will handle the "Pinch" gesture. The pinch gesture is responsible for the zooming.
     - parameter pinch: An UIPinchGestureRecognizer object.
    */
    @objc fileprivate func handlePinchGesture(_ pinch: UIPinchGestureRecognizer) {
        beginZoomScale = beginZoomScale * Float(pinch.scale)
        rtmpStream.setZoomFactor(CGFloat(beginZoomScale))
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
        
        if let captureDevice = DeviceUtil.device(withPosition: currentPosition) {
            do {
                try captureDevice.lockForConfiguration()
                
                captureDevice.focusPointOfInterest = tapPoint
                captureDevice.focusMode = .autoFocus
                captureDevice.exposurePointOfInterest = tapPoint
                captureDevice.exposureMode = .continuousAutoExposure
                captureDevice.unlockForConfiguration()
            } catch {
                
            }
        }
        
        rtmpStream.setPointOfInterest(tapPoint, exposure: tapPoint)
        
    }
    
}
