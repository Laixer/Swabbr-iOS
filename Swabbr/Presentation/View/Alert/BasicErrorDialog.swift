//
//  BasicErrorDialog.swift
//  Swabbr
//
//  Created by James Bal on 07-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

import UIKit

class BasicErrorDialog {
    
    private let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
    
    private init(message: String?, onYesHandler: @escaping (UIAlertAction) -> Void) {
        alert.message = message
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: onYesHandler))
    }
    
    static func createAlert(message: String?, context: UIViewController) {
        let holder = BasicErrorDialog(message: message, onYesHandler: { (_) in
            context.dismiss(animated: true, completion: nil)
        })
        context.present(holder.alert, animated: true, completion: nil)
    }
    
}
