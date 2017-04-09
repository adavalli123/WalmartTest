//
//  DataModel.swift
//  Coding Challenge
//
//  Created by Srikanth Adavalli on 4/7/17.
//  Copyright © 2017 Srikanth Adavalli. All rights reserved.
//

import Foundation
import UIKit

class DataModel: NSObject {
    
    /**
    *   page        :   Used for pagination.
    *   title       :   Title of Movie
    *   overView    :   OverView of the Movie
    *   popularity  :   Movie popularity
    *   posterImage :   ThumbNail Image
    */
    
    var page: Int?
    var original_title: String?
    var overview: String?
    var popularity: NSNumber?
    var poster_path: String?
    var vote_average: NSNumber?
    var image: UIImage?
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
