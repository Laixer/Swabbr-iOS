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
    
    private init(message: String?, onYesHandler: ((UIAlertAction) -> Void)?) {
        alert.message = message
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: onYesHandler ?? { (_) in
            self.alert.dismiss(animated: true, completion: nil)
        }))
    }
    
    static func createAlert(message: String?, context: UIViewController) {
        let holder = BasicErrorDialog(message: message, onYesHandler: nil)
        context.present(holder.alert, animated: true, completion: nil)
    }
    
    static func createAlert(message: String?, handler: @escaping (UIAlertAction) -> Void, context: UIViewController) {
        let holder = BasicErrorDialog(message: message, onYesHandler: handler)
        context.present(holder.alert, animated: true, completion: nil)
    }
    
}
