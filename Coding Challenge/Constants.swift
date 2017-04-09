//
//  Constants.swift
//  Coding Challenge
//
//  Created by Srikanth Adavalli on 4/7/17.
//  Copyright © 2017 Srikanth Adavalli. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let BASE_URL = "https://api.themoviedb.org/3/search/movie?"
    static let API_KEY = "api_key="
    static let API_KEY_VALUE = "a9c170eb2ef7e5d32311cb60b06cfb14"
    static let QUERY = "&query="
    static let PAGE = "&page="
    
    static let BASE_IMAGE_URL = "https://image.tmdb.org/t/p/w500"
    
    static let POST_REQUEST = "POST"
    static let RESPONSE_PARSING_RESULT = "results"
    static let RESPONSE_PARSING_OVERVIEW = "overview"
    static let RESPONSE_PARSING_TITLE = "original_title"
    static let RESPONSE_PARSING_POPULARITY = "popularity"
    static let RESPONSE_PARSING_POSTER = "poster_path"
    
    static let NIB_TABLE_VIEW_CELL = "TableViewCell"
    static let NIB_MORE_TABLE_VIEW_CELL = "MoreTableViewCell"
    
    static let IDENTIFIER_TABLE_VIEW_CELL = "TableViewCell"
    static let IDENTIFIER_TABLE_VIEW_MORE_CELL = "MoreTableViewCell"
    
    static let BAR_BUTTON_TEXT_SUBMIT = "Submit"
    static let BAR_BUTTON_TEXT_CANCEL = "Cancel"
    
    static let SEARCH_TEXT = "Search"
    static let NIL_TEXT = ""
    static let SPINNER_TITLE = "Loading ..."
    
    static let NO_IMAGE = #imageLiteral(resourceName: "no_Img")
    static let SEARCH_IMAGE = #imageLiteral(resourceName: "search")
}
