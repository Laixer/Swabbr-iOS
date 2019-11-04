//
//  VlogPageViewController.swift
//  Swabbr
//
//  Created by James Bal on 17-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
//  This class will handle all Streaming related actions
//
import HaishinKit
import VideoToolbox
import CoreMedia
import AVFoundation

class VlogStreamViewController: VlogMakerBaseViewController {
    
    private let streamUrl: String!
    
    private let maxRetry = 5
    private var retryCount = 0
    
    private let rtmpConnection = RTMPConnection()
    private var rtmpStream: RTMPStream!
    
    init(streamUrl: String) {
        self.streamUrl = streamUrl
        super.init(isStreaming: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
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
        
        controlView.startOperateView {
            self.rtmpConnection.connect(self.streamUrl, arguments: nil)
        }
    }
    
    override func prepareForVlog() {
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
        
        (previewView as! GLHKView).attachStream(self.rtmpStream)
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
    
    override func recordButtonClicked() {
        rtmpStream.close()
        rtmpStream.dispose()
    }
    
    override func switchButtonClicked() {
        let position: AVCaptureDevice.Position = currentPosition == .back ? .front : .back
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: position)) { error in
            print(error)
        }
        currentPosition = position
    }
    
}
