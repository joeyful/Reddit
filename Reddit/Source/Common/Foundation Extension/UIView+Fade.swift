//
//  UIView+Fade.swift
//  Reddit
//
//  Created by Joey Wei on 3/29/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    
    func fadeIn(duration : TimeInterval = 0.3, completion : (()->Void)? = nil) {
        
        isHidden = false
        alpha = 0.0
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        }) { (_) in
            completion?()
        }
    }
    
    
    func fadeIn(completionBlock : @escaping ()->Void) {
        fadeIn(duration: 0.3, completion: completionBlock)
    }
    
    
    func fadeOut(duration : TimeInterval = 0.3, after delay : TimeInterval = 0.0, completion : (()->Void)? = nil) {
        
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
            self.alpha = 0.0
        }) { (_) in
            self.isHidden = true
            completion?()
        }
    }
    
    func fadeOut(completionBlock : @escaping ()->Void) {
        fadeOut(duration: 0.3, completion: completionBlock)
    }
    
    func fadeInOut(duration : TimeInterval = 0.6) {
        
        let phaseDuration = duration / 3.0
        
        fadeIn(duration: phaseDuration) {
            self.fadeOut(duration: phaseDuration, after: phaseDuration)
        }
    }
    
}
