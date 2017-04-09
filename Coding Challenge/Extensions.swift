//
//  Extensions.swift
//  Coding Challenge
//
//  Created by Srikanth Adavalli on 4/7/17.
//  Copyright © 2017 Srikanth Adavalli. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /**
     *  @customNavController :  is used for custom Navigation Bar
     *  barStyle (optional)  :  setting Navigation Bar Style
     *  tintColor(optional)  :  setting tintColor
     */
    
    func customNavController(barStyle: UIBarStyle?, tintColor: UIColor?) {
        let navBar = self.navigationController?.navigationBar
        
        if let barStyle = barStyle {
            navBar?.barStyle = barStyle
        }
        else {
            navBar?.barStyle = UIBarStyle.blackOpaque
        }
        
        if let tintColor = tintColor {
            navBar?.tintColor = tintColor
        }
        else {
            navBar?.tintColor = UIColor.white
        }
    }
}

extension RawRepresentable where RawValue == String, Self: NotificationName {
    var name: Notification.Name {
        get {
            return Notification.Name(self.rawValue)
        }
    }
}
