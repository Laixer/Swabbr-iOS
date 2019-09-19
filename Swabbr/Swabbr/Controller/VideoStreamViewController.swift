//
//  VideoPageViewController.swift
//  Swabbr
//
//  Created by Anonymous on 17-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
//  This class will handle all Streaming related actions
//

import Foundation
import UIKit
import SwiftyCam

class VideoStreamViewController : SwiftyCamViewController {
    
    override func viewDidLoad() {
        // set preview to fill whole screen
        videoGravity = .resizeAspectFill
        super.viewDidLoad()
        doubleTapCameraSwitch = false
        cameraDelegate = self
    }
    
    @IBAction func clickedRecordButton(_ sender: UIButton) {
    }
    
    @IBAction func clickedCameraSwitchButton(_ sender: Any) {
        switchCamera()
    }
    
}

// extension to add delegate of swiftycam to the class
extension VideoStreamViewController : SwiftyCamViewControllerDelegate {
    
}
