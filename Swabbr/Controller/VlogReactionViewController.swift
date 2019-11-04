//
//  VlogReactionViewController.swift
//  Swabbr
//
//  Created by James Bal on 04-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation
import NextLevel
import Photos

class VlogReactionViewController: VlogMakerBaseViewController {
    
    private let nextLevel = NextLevel.shared
    
    private var vlog: Vlog?
    
    init(vlog: Vlog?) {
        self.vlog = vlog
        super.init(isStreaming: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        nextLevel.videoConfiguration.maximumCaptureDuration = CMTimeMakeWithSeconds(8, preferredTimescale: 60)
        nextLevel.audioConfiguration.bitRate = 44100
        
        nextLevel.videoDelegate = self
        
        controlView.startOperateView {
            self.nextLevel.record()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        nextLevel.stop()
    }
    
    override func prepareForVlog() {
        try! nextLevel.start()
    }
    
    override func recordButtonClicked() {
        endCapture()
        nextLevel.session?.removeAllClips()
    }
    
    override func switchButtonClicked() {
        nextLevel.flipCaptureDevicePosition()
        currentPosition = nextLevel.devicePosition
    }
    
}

extension VlogReactionViewController {
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

extension VlogReactionViewController: NextLevelVideoDelegate {
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
        endCapture()
        nextLevel.session?.removeAllClips()
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCompletePhotoCaptureFromVideoFrame photoDict: [String : Any]?) {
        
    }
    
    
}
