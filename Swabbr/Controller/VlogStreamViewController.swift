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

class VlogStreamViewController : UIViewController {
    
    /// camera library instance
    private let nextLevel = NextLevel()
    
    private var previewView: UIView?
    
    private let controlView = VlogStreamControlView()
    
    fileprivate var beginZoomScale: Float = 1.0
    fileprivate var focusView = FocusIndicatorView(frame: .zero)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
//        NextLevel.shared.videoConfiguration.maximumCaptureDuration = CMTimeMakeWithSeconds(5, preferredTimescale: 600)
        nextLevel.audioConfiguration.bitRate = 44000
        
        view.addSubview(controlView)
        
        controlView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            controlView.topAnchor.constraint(equalTo: view.topAnchor),
            controlView.leftAnchor.constraint(equalTo: view.leftAnchor),
            controlView.rightAnchor.constraint(equalTo: view.rightAnchor),
            controlView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
        
        controlView.startOperateView {
            self.nextLevel.record()
        }
        
        controlView.recordButton.addTarget(self, action: #selector(recordButtonClicked), for: .touchUpInside)
        controlView.flipCameraTopLeftButton.addTarget(self, action: #selector(switchButtonClicked), for: .touchUpInside)
        controlView.flipCameraBottomRightButton.addTarget(self, action: #selector(switchButtonClicked), for: .touchUpInside)
        
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
        do {
            try nextLevel.start()
        } catch {
            print(error)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nextLevel.stop()
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

/// handle all gestures here
extension VlogStreamViewController : UIGestureRecognizerDelegate {
    
    /// add actions when a gesture is about to begin
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPinchGestureRecognizer.self) {
            beginZoomScale = nextLevel.videoZoomFactor
        }
        return true
    }
    
    /// handles the zooming pinch gesture
    @objc fileprivate func handlePinchGesture(_ pinch: UIPinchGestureRecognizer) {
        beginZoomScale = beginZoomScale * Float(pinch.scale)
        nextLevel.videoZoomFactor = beginZoomScale
    }
    
    /// handles the single tap focus gesture
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
