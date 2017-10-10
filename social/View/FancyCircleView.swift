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
    
    //function for editing the view. Will be used to change the image shape to circle
    override func layoutSubviews() {
        //The function helps include the frame size which can be used in the calculation
        layer.cornerRadius = self.frame.width / 2
    }
    
}
