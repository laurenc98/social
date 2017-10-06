//
//  FancyField.swift
//  social
//
//  Created by Lauren Charlton on 06/10/2017.
//  Copyright © 2017 Lauren Charlton. All rights reserved.
//

import UIKit
//Create border and indentation
class FancyField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        //Creating a border for the text fields
        //This step sets the colour to the grey
        layer.borderColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.2).cgColor
        //Width of border (thickness)
        layer.borderWidth = 1.0
        //corner radius
        layer.cornerRadius = 2.0
    }
    
    //Sorting out indent
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        //direction it'll move the text
        return bounds.insetBy(dx: 10, dy: 5)
    }
    //This is to keep the indent the same when a user is editing the text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }

}
