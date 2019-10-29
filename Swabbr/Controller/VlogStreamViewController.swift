//
//  VlogPageViewController.swift
//  Swabbr
//
//  Created by James Bal on 17-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
//  This class will handle all Streaming related actions
//

import Foundation
import UIKit
import NextLevel
import CoreMedia
import AVFoundation
import Photos

class VlogStreamViewController : UIViewController, BaseViewProtocol {
    
    private let nextLevel = NextLevel()
    
    private var previewView: UIView?
    
    private let controlView: VlogStreamControlView!
    
    fileprivate var beginZoomScale: Float = 1.0
    fileprivate var focusView = FocusIndicatorView(frame: .zero)
    
    let isStreaming: Bool!
    
    init(isStreaming: Bool) {
        self.controlView = VlogStreamControlView(isStreaming: isStreaming)
        self.isStreaming = isStreaming
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initElements()
        applyConstraints()
        
        nextLevel.videoDelegate = self
        nextLevel.audioConfiguration.bitRate = 44000
        
        controlView.startOperateView {
            self.nextLevel.record()
        }
        
        controlView.recordButton.addTarget(self, action: #selector(recordButtonClicked), for: .touchUpInside)
        controlView.flipCameraTopLeftButton.addTarget(self, action: #selector(switchButtonClicked), for: .touchUpInside)
        controlView.flipCameraBottomRightButton.addTarget(self, action: #selector(switchButtonClicked), for: .touchUpInside)
        
    }
    
    internal func initElements() {
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        pinchGesture.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTapGesture(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        
        let screenBounds = UIScreen.main.bounds
        self.previewView = UIView(frame: screenBounds)
        if let previewView = self.previewView {
            previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            previewView.backgroundColor = UIColor.black
            previewView.addGestureRecognizer(pinchGesture)
            previewView.addGestureRecognizer(tapGesture)
            self.nextLevel.previewLayer.frame = previewView.bounds
            previewView.layer.addSublayer(self.nextLevel.previewLayer)
            self.view.addSubview(previewView)
        }
        
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
        endCapture()
        nextLevel.session?.removeAllClips()
    }
    
    @objc func switchButtonClicked() {
        nextLevel.flipCaptureDevicePosition()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
            NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
            do {
                try self.nextLevel.start()
            } catch {
                print("NextLevel, failed to start camera session")
            }
        } else {
            NextLevel.requestAuthorization(forMediaType: AVMediaType.video) { (mediaType, status) in
                print("NextLevel, authorization updated for media \(mediaType) status \(status)")
                if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
                    NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
                    do {
                        try self.nextLevel.start()
                    } catch {
                        print("NextLevel, failed to start camera session")
                    }
                } else if status == .notAuthorized {
                    // gracefully handle when audio/video is not authorized
                    print("NextLevel doesn't have authorization for audio or video")
                }
            }
            NextLevel.requestAuthorization(forMediaType: AVMediaType.audio) { (mediaType, status) in
                print("NextLevel, authorization updated for media \(mediaType) status \(status)")
                if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
                    NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
                    do {
                        try self.nextLevel.start()
                    } catch {
                        print("NextLevel, failed to start camera session")
                    }
                } else if status == .notAuthorized {
                    // gracefully handle when audio/video is not authorized
                    print("NextLevel doesn't have authorization for audio or video")
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nextLevel.stop()
    }
    
}

// MARK: UIGestureRecognizerDelegate
extension VlogStreamViewController : UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPinchGestureRecognizer.self) {
            beginZoomScale = nextLevel.videoZoomFactor
        }
        return true
    }
    
    /**
     This will handle the "Pinch" gesture. The pinch gesture is responsible for the zooming.
     - parameter pinch: An UIPinchGestureRecognizer object.
    */
    @objc fileprivate func handlePinchGesture(_ pinch: UIPinchGestureRecognizer) {
        beginZoomScale = beginZoomScale * Float(pinch.scale)
        nextLevel.videoZoomFactor = beginZoomScale
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
        
        let adjustedPoint = nextLevel.previewLayer.captureDevicePointConverted(fromLayerPoint: tapPoint)
        nextLevel.focusExposeAndAdjustWhiteBalance(atAdjustedPoint: adjustedPoint)
        
    }
    
}

extension VlogStreamViewController : NextLevelVideoDelegate {
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoZoomFactor videoZoomFactor: Float) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, willProcessRawVideoSampleBuffer sampleBuffer: CMSampleBuffer, onQueue queue: DispatchQueue) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, renderToCustomContextWithImageBuffer imageBuffer: CVPixelBuffer, onQueue queue: DispatchQueue) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, willProcessFrame frame: AnyObject, pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, onQueue queue: DispatchQueue) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSetupVideoInSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSetupAudioInSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didStartClipInSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCompleteClip clip: NextLevelClip, inSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendVideoSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipVideoSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendVideoPixelBuffer pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, inSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipVideoPixelBuffer pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, inSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendAudioSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipAudioSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCompleteSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCompletePhotoCaptureFromVideoFrame photoDict: [String : Any]?) {
        
    }
}

extension VlogStreamViewController {
    
    internal func endCapture() {
        if let session = nextLevel.session {
            
            if session.clips.count > 1 {
                session.mergeClips(usingPreset: AVAssetExportPresetHighestQuality, completionHandler: { (url: URL?, error: Error?) in
                    if let url = url {
                        self.saveVideo(withURL: url)
                    } else if let _ = error {
                        print("failed to merge clips at the end of capture \(String(describing: error))")
                    }
                })
            } else if let lastClipUrl = session.lastClipUrl {
                self.saveVideo(withURL: lastClipUrl)
            } else if session.currentClipHasStarted {
                session.endClip(completionHandler: { (clip, error) in
                    if error == nil {
                        self.saveVideo(withURL: (clip?.url)!)
                    } else {
                        print("Error saving video: \(error?.localizedDescription ?? "")")
                    }
                })
            } else {
                // prompt that the video has been saved
                let alertController = UIAlertController(title: "Video Failed", message: "Not enough video captured!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
    internal func albumAssetCollection(withTitle title: String) -> PHAssetCollection? {
        let predicate = NSPredicate(format: "localizedTitle = %@", title)
        let options = PHFetchOptions()
        options.predicate = predicate
        let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        if result.count > 0 {
            return result.firstObject
        }
        return nil
    }
    
    internal func saveVideo(withURL url: URL) {
        let NextLevelAlbumTitle = "NextLevel"
        
        PHPhotoLibrary.shared().performChanges({
            let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle)
            if albumAssetCollection == nil {
                let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: NextLevelAlbumTitle)
                let _ = changeRequest.placeholderForCreatedAssetCollection
            }}, completionHandler: { (success1: Bool, error1: Error?) in
                if let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle) {
                    PHPhotoLibrary.shared().performChanges({
                        if let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url) {
                            let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                            let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                            assetCollectionChangeRequest?.addAssets(enumeration)
                        }
                    }, completionHandler: { (success2: Bool, error2: Error?) in
                        if success2 == true {
                            // prompt that the video has been saved
                            let alertController = UIAlertController(title: "Video Saved!", message: "Saved to the camera roll.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                DispatchQueue.main.async {
                                    
                                }
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        } else {
                            // prompt that the video has been saved
                            let alertController = UIAlertController(title: "Oops!", message: "Something failed!", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    })
                }
        })
    }
}
