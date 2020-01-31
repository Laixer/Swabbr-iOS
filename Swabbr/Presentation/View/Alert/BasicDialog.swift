//
//  BasicDialog.swift
//  Swabbr
//
//  Created by James Bal on 07-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

import UIKit

class BasicDialog {
    
    private let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    
    private init(title: String?, message: String?, onYesHandler: ((UIAlertAction) -> Void)?) {
        alert.title = title
        alert.message = message
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: onYesHandler ?? { (_) in
            self.alert.dismiss(animated: true, completion: nil)
        }))
    }
    
    static func createAlert(title: String = "Error", message: String?, handler: ((UIAlertAction) -> Void)? = nil, context: UIViewController) {
        let holder = BasicDialog(title: title, message: message, onYesHandler: handler)
        context.present(holder.alert, animated: true, completion: nil)
    }
    
}
