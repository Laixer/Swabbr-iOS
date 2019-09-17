//
//  CameraHandler.swift
//  Swabbr
//
//  Created by Anonymous on 16-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import AVFoundation
import UIKit

class CameraHandler : PermissionHandlerProtocol {
    
    static var hasPermission: Bool = false
    
    // ask for permission
    private static func askPermission() {
        
        // check current status of video permission
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied, .restricted:
            return
        case .authorized:
            // set permission to true if already authorized
            hasPermission = true
            break
        case .notDetermined:
            // ask device to get permission to camera for video
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    hasPermission = true
                }
            }
        }
        
    }
    
    
    // create an error dialog window if error permission error occurs
    static func createErrorDialog(rootView: UIViewController) {
        // handle alert in main thread to prevent "view not on current stack" error
        DispatchQueue.main.async {
            let errorAlert = UIAlertController(title: "Permissions", message: "Camera and the microphone is required", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            rootView.present(errorAlert, animated: true, completion: nil)
        }
    }
    
}
