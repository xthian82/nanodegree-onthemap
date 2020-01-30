//
//  TextFieldDelegate.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/30/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
   }
}
