//
//  KennyHatEyes.swift
//  EmojiSportsTracker
//
//  Created by Michael Wintsch on 03/12/2015.
//  Copyright © 2015 Michael Wintsch. All rights reserved.
//

import UIKit


class KennyHatEyes: UIView {
    
    public var eyeColor : Bool = false
    
    public var eyeLeftOrRight : Bool = false

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        
        
        
        
        // Drawing code
        
        if (!eyeColor)
        {
            
            // for the moment if false then choose greenColor
            
            if (!eyeLeftOrRight)
            {
                // false = Left
                
                KennyHat.drawEyeLeft(variableColor: KennyHat.fillColorGreen, ourRect: rect)
                
            }
            else
            {
                
                KennyHat.drawEyeRight(variableColor: KennyHat.fillColorGreen, ourRect: rect)
                
            }
            
            
            
        }
        else
        {
            
            // if true then Red Color...
            
            if (!eyeLeftOrRight)
            {
                
                // false = left
                
                KennyHat.drawEyeLeft(variableColor: KennyHat.fillRedColor, ourRect: rect)
                
            }
            else
            {
                
                KennyHat.drawEyeRight(variableColor: KennyHat.fillRedColor, ourRect: rect)
                
            }
            
            
            
        }
        
        
        
        
    }
    
    
   

}
