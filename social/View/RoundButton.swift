//
//  RoundButton.swift
//  social
//
//  Created by Lauren Charlton on 06/10/2017.
//  Copyright © 2017 Lauren Charlton. All rights reserved.
//

import UIKit
//Change the look of the button
class RoundButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        //Shadow effect
        //Shadow colour setting. It uses the SHADOW_GREY constant from the constants file and sets it as a grey colour
        layer.shadowColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.6).cgColor
        //Shadow opacity
        layer.shadowOpacity = 0.8
        //Shadow radius (shadow span distance)
        layer.shadowRadius = 5.0
        //Shadow offset (where the shadow is located from the view)
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        //On buttons sometimes the content mode on the storyboard doesn't always work. This just helps ensure that it does
        imageView?.contentMode = .scaleAspectFit
        
    }
    //function for editing the view. Will be used to change the button shape to circle
    override func layoutSubviews() {
        super.layoutSubviews()
        //The function helps include the frame size which can be used in the calculation
        layer.cornerRadius = self.frame.width / 2
    }

}
