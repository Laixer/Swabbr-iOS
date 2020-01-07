//
//  NoAudioOrCameraPermissionsAlertDialog.swift
//  Swabbr
//
//  Created by James Bal on 19-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit

class NoAudioOrCameraPermissionsAlertDialog {
    
    private let alert = UIAlertController(title: "Missing permissions", message: "No permission given to use audio and/ or video.", preferredStyle: .alert)
    
    private init(onYesHandler: @escaping (UIAlertAction) -> Void) {
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: onYesHandler))
    }
    
    static func createAlert(context: UIViewController, onYesHandler: @escaping (UIAlertAction) -> Void) {
        let holder = NoAudioOrCameraPermissionsAlertDialog(onYesHandler: onYesHandler)
        context.present(holder.alert, animated: true, completion: nil)
    }
    
}
