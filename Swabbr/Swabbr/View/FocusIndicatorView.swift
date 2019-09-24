//
//  FocusIndicatorView.swift
//  Swabbr
//
//  Created by James Bal on 24-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
//  Inspired by NextLevel FocusIndicatorView.swift

import Foundation
import UIKit

class FocusIndicatorView: UIView {
    
    // the frame used to indicate region being focused on
    private var focusRingRectangle = Rectangle(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 100)))
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        focusRingRectangle.backgroundColor = .clear
        focusRingRectangle.alpha = 0
        self.addSubview(focusRingRectangle)
        self.frame = self.focusRingRectangle.frame
        
        self.prepareAnimation()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.focusRingRectangle.layer.removeAllAnimations()
    }
}

extension FocusIndicatorView {
    
    fileprivate func prepareAnimation() {
        // prepare animation
        self.focusRingRectangle.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.focusRingRectangle.alpha = 0
    }
    
    public func startAnimation() {
        self.focusRingRectangle.layer.removeAllAnimations()
        
        // animate
        UIView.animate(withDuration: 0.2) {
            self.focusRingRectangle.alpha = 1
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.focusRingRectangle.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }) { (completed) in
            if completed {
                self.stopAnimation()
            }
            
        }
    }
    
    public func stopAnimation() {
        self.focusRingRectangle.layer.removeAllAnimations()
        
        UIView.animate(withDuration: 0.2) {
            self.focusRingRectangle.alpha = 0
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.focusRingRectangle.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (completed) in
            if completed {
                self.removeFromSuperview()
            }
        }
    }
    
}

/// Rectangle class to handle the cgrect functions
fileprivate class Rectangle: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let h = rect.height
        let w = rect.width
        
        let color:UIColor = UIColor.white
        
        let drect = CGRect(x: rect.minX,y: rect.minY,width: w,height: h)
        let bpath:UIBezierPath = UIBezierPath(rect: drect)
        
        color.set()
        bpath.stroke()
        
    }
    
}
