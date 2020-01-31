//
//  UIImage+ImageFromUrl.swift
//  Swabbr
//
//  Created by James Bal on 09-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

extension UIImageView {
    
    static let imageCache = NSCache<NSString, UIImage>()
    
    /**
     Display an image from a remote url.
     - parameter url: A String value which represents the url.
    */
    func imageFromUrl(_ url: String) {
        
        if let cachedImage = UIImageView.imageCache.object(forKey: url as NSString) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            return
        }
        
        if let _url = URL(string: url) {
            URLSession.shared.dataTask(with: _url, completionHandler: { data, _, _ in
                guard let data = data else {
                    return
                }
                DispatchQueue.main.async { [unowned self] in
                    self.image = UIImage(data: data)
                    UIImageView.imageCache.setObject(self.image!, forKey: url as NSString)
                }
            }).resume()
        }
    }
}
