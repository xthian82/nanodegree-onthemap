//
//  RoundButton.swift
//  OnTheMap
//
//  Created by Cristhian Jesus Recalde Franco on 1/28/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        layer.cornerRadius = 5
        tintColor = UIColor.white
        backgroundColor = UIColor.systemBlue
    }
}
