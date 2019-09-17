//
//  CameraPreviewView.swift
//  Swabbr
//
//  Created by Anonymous on 16-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPreviewView : UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
