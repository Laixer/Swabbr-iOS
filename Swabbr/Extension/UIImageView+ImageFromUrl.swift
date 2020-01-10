//
//  UIImage+ImageFromUrl.swift
//  Swabbr
//
//  Created by James Bal on 09-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

extension UIImageView {
    func imageFromUrl(_ url: String) {
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}
