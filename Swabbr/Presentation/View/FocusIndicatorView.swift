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
    
    /**
     Prepare the animation by setting values to their appropiate values.
    */
    fileprivate func prepareAnimation() {
        // prepare animation
        self.focusRingRectangle.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.focusRingRectangle.alpha = 0
    }
    
    /**
     Start with the animation for the indicator view.
     It consists of 2 seperate animations as dicussed below.
     When the animation is finished it will call the stopAnimation function.
     - First animation will handle the alpha of the rectangle.
     - Second animation will handle the scale of the rectangle.
    */
    public func startAnimation() {
        self.focusRingRectangle.layer.removeAllAnimations()
        
        // animate
        UIView.animate(withDuration: 0.2) {
            self.focusRingRectangle.alpha = 1
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.focusRingRectangle.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }, completion: { (completed) in
            if completed {
                self.stopAnimation()
            }
        })
    }
    
    /**
     This is responsible to animate back to the default values.
     It consists of 2 seperate animations as dicussed below.
     After it is completely finished it will remove this view from the superview
     - First animation will handle the alpha of the rectangle.
     - Second animation will handle the scale of the rectangle.
    */
    public func stopAnimation() {
        self.focusRingRectangle.layer.removeAllAnimations()
        
        UIView.animate(withDuration: 0.2) {
            self.focusRingRectangle.alpha = 0
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.focusRingRectangle.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { (completed) in
            if completed {
                self.removeFromSuperview()
            }
        })
    }
    
}

private class Rectangle: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let height = rect.height
        let width = rect.width
        
        let color: UIColor = UIColor.white
        
        let drect = CGRect(x: rect.minX, y: rect.minY, width: width, height: height)
        let bpath: UIBezierPath = UIBezierPath(rect: drect)
        
        color.set()
        bpath.stroke()
        
    }
    
}
