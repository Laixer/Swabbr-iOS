//
//  VlogPageViewController.swift
//  Swabbr
//
//  Created by James Bal on 17-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
//  This class will handle all Streaming related actions
//

// swiftlint:disable large_tuple

import VideoToolbox
import CoreMedia
import AVFoundation

class VlogStreamViewController: VlogMakerBaseViewController, WOWZBroadcastStatusCallback, WOWZVideoSink, WOWZAudioSink {
    
    let sdkAppLicenseKey = "GOSK-1F47-010C-632D-5825-C587"
    
    private var goCoder: WowzaGoCoder?
    private let goCoderConfig = WowzaConfig()
    
    private let controllerService = VlogStreamViewControllerService()
    
    private var frameImage: UIImage?
    
    let modalHandler = ModalHandler()
    
    /**
     # Notes: #
     1. id: String
     2. hostAddress: String
     3. applicationName: String
     4. streamName: String
     5. portNumber: UInt
     6. username: String
     7. password: String
    */
    private let streamCreds: (String, String, String, String, UInt, String, String)
    
    init(creds: (String, String, String, String, UInt, String, String)) {
        self.streamCreds = creds
        super.init(isStreaming: true)
        controllerService.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "Streaming View"
        
        modalHandler.delegate = self
        
        if let goCoderLicensingError = WowzaGoCoder.registerLicenseKey(sdkAppLicenseKey) {
            print(goCoderLicensingError)
            return
        }

        goCoder = WowzaGoCoder.sharedInstance()

        goCoder!.cameraView = self.previewView
        goCoder!.cameraPreview?.previewGravity = .resizeAspectFill
        goCoder!.cameraPreview?.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        goCoderConfig.hostAddress = streamCreds.1
        goCoderConfig.applicationName = streamCreds.2
        goCoderConfig.streamName = streamCreds.3
        goCoderConfig.portNumber = streamCreds.4
        goCoderConfig.username = streamCreds.5
        goCoderConfig.password = streamCreds.6
        
        goCoderConfig.load(.preset1920x1080)
        goCoderConfig.broadcastVideoOrientation = .alwaysPortrait
        goCoderConfig.broadcastScaleMode = .aspectFit
        
        goCoder!.register(self as WOWZAudioSink)
        goCoder!.register(self as WOWZVideoSink)
        goCoder!.config = self.goCoderConfig
    }
    
    override func prepareForVlog() {
        
        controlView!.startOperateView { [unowned self] in
            self.controllerService.startLive(id: self.streamCreds.0)
        }
        
    }
    
    func onWOWZStatus(_ status: WOWZBroadcastStatus!) {
        switch status.state {
        case .idle:
            print("idle")
        case .broadcasting:
            print("broadcast")
        default:
            break
        }
    }
    
    func onWOWZError(_ status: WOWZBroadcastStatus!) {
        BasicDialog.createAlert(message: String(describing: status), handler: { [weak self](_) in
            self?.goCoder?.endStreaming(self)
            self?.dismiss(animated: true, completion: nil)
            }, context: self)
    }
    
    func videoFrameWasCaptured(_ imageBuffer: CVImageBuffer, framePresentationTime: CMTime, frameDuration: CMTime) {
        guard let goCoder = goCoder else {
            return
        }
        if goCoder.isStreaming && frameImage == nil {
            let frameImage = CIImage(cvImageBuffer: imageBuffer)
            self.frameImage = UIImage(ciImage: frameImage)
        }
    }
    
    override func recordButtonClicked() {
        controllerService.endLive(id: streamCreds.0)
    }
    
    override func switchButtonClicked() {
        if let otherCamera = goCoder?.cameraPreview?.otherCamera() {
            if !otherCamera.supportsWidth(goCoderConfig.videoWidth) {
                goCoderConfig.load(otherCamera.supportedPresetConfigs.last!.toPreset())
                goCoder?.config = goCoderConfig
            }
            goCoder?.cameraPreview?.switchCamera()
            // currentPosition
        }
    }
    
    deinit {
        self.goCoder?.unregisterAudioSink(self as WOWZAudioSink)
        self.goCoder?.unregisterVideoSink(self as WOWZVideoSink)
        self.goCoder?.cameraPreview?.stop()
        self.goCoder = nil
    }
    
}

extension VlogStreamViewController: VlogStreamViewControllerServiceDelegate {
    func tryStartingStream(errorString: String?) {
        goCoder?.startStreaming(self)
        guard errorString == nil else {
            BasicDialog.createAlert(message: errorString, handler: { [weak self](_) in
                self?.dismiss(animated: true, completion: nil)
            }, context: self)
            return
        }
    }
    
    func tryEndingStream(errorString: String?) {
        goCoder?.endStreaming(self)
        if let errorString = errorString {
            BasicDialog.createAlert(message: errorString, handler: { [weak self](_) in
                self?.dismiss(animated: true, completion: nil)
                }, context: self)
            return
        }
        show(UINavigationController(rootViewController: VlogPreviewViewController(vlogId: streamCreds.0,
                                                                                  image: frameImage!,
                                                                                  context: modalHandler)), sender: nil)
    }
    
}

extension VlogStreamViewController: ModalHandlerDelegate {
    func dismissModals() {
        presentedViewController?.dismiss(animated: true, completion: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        })
    }
}

// TODO: SHOULD BE A CLEANER WAY
protocol ModalHandlerDelegate: class {
    
    func dismissModals()
    
}

class ModalHandler {
    
    weak var delegate: ModalHandlerDelegate?
    
    func dismissAllModals() {
        delegate?.dismissModals()
    }
    
}
