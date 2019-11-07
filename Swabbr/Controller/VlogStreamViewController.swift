//
//  VlogPageViewController.swift
//  Swabbr
//
//  Created by James Bal on 17-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
//  This class will handle all Streaming related actions
//
//import HaishinKit
import VideoToolbox
import CoreMedia
import AVFoundation

class VlogStreamViewController: VlogMakerBaseViewController, WOWZBroadcastStatusCallback, WOWZVideoSink, WOWZAudioSink {
    
    
    var goCoder: WowzaGoCoder?
    let goCoderConfig = WowzaConfig()
    
    init() {
        super.init(isStreaming: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        controlView.startOperateView {
            self.goCoder?.startStreaming(self)
        }
    }
    
    override func prepareForVlog() {
        
        
        goCoderConfig.load(.preset1280x720)
        goCoderConfig.broadcastScaleMode = .aspectFit
        goCoderConfig.videoWidth = 1280
        goCoderConfig.videoHeight = 720
        
        if let goCoderLicensingError = WowzaGoCoder.registerLicenseKey(sdkAppLicenseKey) {
            print("error license")
            return
        }
        
        if let goCoder = WowzaGoCoder.sharedInstance() {
            self.goCoder = goCoder
            
            self.goCoder?.register(self as WOWZAudioSink)
            self.goCoder?.register(self as WOWZVideoSink)
            self.goCoder?.config = self.goCoderConfig
            
            self.goCoder?.cameraView = self.previewView
            self.goCoder?.cameraPreview?.start()
        }
        
        goCoder?.cameraPreview?.previewLayer!.videoGravity = .resizeAspectFill

    }
    
    override func viewDidLayoutSubviews() {
        goCoder?.cameraPreview?.previewLayer!.frame = view.bounds
    }
    
    func videoFrameWasCaptured(_ imageBuffer: CVImageBuffer, framePresentationTime: CMTime, frameDuration: CMTime) {
        
    }
    
    func onWOWZStatus(_ status: WOWZBroadcastStatus!) {
        switch(status.state) {
        case .idle:
            print("idle")
        case .broadcasting:
            print("broadcast")
        default:
            break
        }
    }
    
    func onWOWZError(_ status: WOWZBroadcastStatus!) {
        print("error \(status)")
    }
    
    override func recordButtonClicked() {
        goCoder?.endStreaming(self)
    }
    
    override func switchButtonClicked() {
        if let otherCamera = goCoder?.cameraPreview?.otherCamera() {
            if !otherCamera.supportsWidth(goCoderConfig.videoWidth) {
                goCoderConfig.load(otherCamera.supportedPresetConfigs.last!.toPreset())
                goCoder?.config = goCoderConfig
            }
            
            goCoder?.cameraPreview?.switchCamera()
        }
    }
}
