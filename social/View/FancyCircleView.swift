//
//  FancyCircleView.swift
//  social
//
//  Created by Lauren Charlton on 10/10/2017.
//  Copyright © 2017 Lauren Charlton. All rights reserved.
//

import UIKit
//circle the images
class FancyCircleView: UIImageView {
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
    }
    
    //function for editing the view. Will be used to change the image shape to circle
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //The function helps include the frame size which can be used in the calculation
        layer.cornerRadius = self.frame.width / 2
    }
}
