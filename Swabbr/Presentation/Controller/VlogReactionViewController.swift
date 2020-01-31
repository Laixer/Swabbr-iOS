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
import VideoToolbox

class VlogReactionViewController: VlogMakerBaseViewController {
    
    private let nextLevel = NextLevel.shared
    private var started = false
    
    private let vlogId: String
    
    private var thumbImage: UIImage?
    
    let modalHandler = ModalHandler()

    init(vlogId: String) {
        self.vlogId = vlogId
        super.init(isStreaming: false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

        nextLevel.videoConfiguration.maximumCaptureDuration = CMTimeMakeWithSeconds(8, preferredTimescale: 60)
        nextLevel.audioConfiguration.bitRate = 44100
        nextLevel.videoConfiguration.preset = .hd1280x720
        nextLevel.videoConfiguration.bitRate = 5500000
        nextLevel.videoConfiguration.maxKeyFrameInterval = 30
        nextLevel.videoConfiguration.profileLevel = AVVideoProfileLevelH264HighAutoLevel

        nextLevel.deviceDelegate = self
        nextLevel.videoDelegate = self
        
        modalHandler.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        try? nextLevel.start()
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nextLevel.stop()
    }

    override func prepareForVlog() {
        controlView!.startOperateView { [unowned self] in
            self.nextLevel.record()
            self.nextLevel.capturePhotoFromVideo()
        }
    }

    override func recordButtonClicked() {
        nextLevel.pause(withCompletionHandler: { [unowned self] in
            self.endCapture()
        })
    }

    override func switchButtonClicked() {
        nextLevel.flipCaptureDevicePosition()
        currentPosition = nextLevel.devicePosition
    }

}

extension VlogReactionViewController {
    internal func endCapture() {
        
        nextLevel.stop()

        guard let session = nextLevel.session else {
            return
        }

        if session.clips.count > 1 {
            session.mergeClips(usingPreset: AVAssetExportPresetHighestQuality, completionHandler: { [unowned self] (url: URL?, error: Error?) in
                if let url = url {
                    self.saveVideo(withURL: url)
                } else if error != nil {
                    print("failed to merge clips at the end of capture \(String(describing: error))")
                }
            })
        } else if let lastClipUrl = session.lastClipUrl {
            self.saveVideo(withURL: lastClipUrl)
        } else if session.currentClipHasStarted {
            session.endClip(completionHandler: { [unowned self] (clip, error) in
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

    internal func saveVideo(withURL url: URL) {
        show(UINavigationController(rootViewController: VlogPreviewViewController(vlogId: "",
                                                                                     image: thumbImage!,
                                                                                     context: modalHandler)),
             sender: nil)
    }
}

extension VlogReactionViewController: NextLevelDeviceDelegate {
    func nextLevel(_ nextLevel: NextLevel, didChangeLensPosition lensPosition: Float) {
        
    }
    
    func nextLevelDevicePositionWillChange(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDevicePositionDidChange(_ nextLevel: NextLevel) {
        if !started {
            started = true
            return
        }
        nextLevel.pause(withCompletionHandler: {
            nextLevel.record()
        })
    }
    
    func nextLevel(_ nextLevel: NextLevel, didChangeDeviceOrientation deviceOrientation: NextLevelDeviceOrientation) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didChangeDeviceFormat deviceFormat: AVCaptureDevice.Format) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didChangeCleanAperture cleanAperture: CGRect) {
        
    }
    
    func nextLevelWillStartFocus(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelDidStopFocus(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelWillChangeExposure(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelDidChangeExposure(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelWillChangeWhiteBalance(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelDidChangeWhiteBalance(_ nextLevel: NextLevel) {
        
    }
    
}

extension VlogReactionViewController: NextLevelVideoDelegate {
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoZoomFactor videoZoomFactor: Float) {

    }

    func nextLevel(_ nextLevel: NextLevel, willProcessRawVideoSampleBuffer sampleBuffer: CMSampleBuffer, onQueue queue: DispatchQueue) {
        // pause
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
    }

    func nextLevel(_ nextLevel: NextLevel, didCompletePhotoCaptureFromVideoFrame photoDict: [String: Any]?) {
        if thumbImage == nil {
            if let dictionary = photoDict,
                let photoData = dictionary[NextLevelPhotoJPEGKey] as? Data,
                let photoImage = UIImage(data: photoData) {
                thumbImage = photoImage
            }
        }
    }

}

extension VlogReactionViewController: ModalHandlerDelegate {
    func dismissModals() {
        presentedViewController?.dismiss(animated: true, completion: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        })
    }
}
