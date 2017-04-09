//
//  NetworkRequest.swift
//  Coding Challenge
//
//  Created by Srikanth Adavalli on 4/7/17.
//  Copyright © 2017 Srikanth Adavalli. All rights reserved.
//

import Foundation
import UIKit

class NetworkRequestor {
    
    func getRequest(path: URLRequest, completionHandler: @escaping (Data?, Error?) -> ())
    {
        let task = URLSession.shared.dataTask(with: path as URLRequest, completionHandler: {data, response, error in
            
            /// Handling error handling scenario's
            if let error = error {
                // If we got service error while trying to get data from the server.
                completionHandler(nil, error)
            }
                
                /// Handling success path.
            else {
                completionHandler(data, nil)
            }
            
        })
        task.resume()
    }
    
    func sendRequest(query: String, page:String, completionHandler: @escaping ([DataModel]?, Error?) -> Void) {
        let fullPath = Constants.BASE_URL+Constants.API_KEY+Constants.API_KEY_VALUE+Constants.QUERY+query+Constants.PAGE+page
        
        if let fullPath = fullPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let request = URLRequest(url: URL(string: fullPath)!)
            
            self.getRequest(path: request) { [weak self] (data, error) in
                
                if let error = error {
                    completionHandler(nil, error)
                }
                
                if let data = data {
                    
                    do {
                        guard let responseData: [String: AnyObject] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject] else {
                            return
                        }
                        
                        guard let resultsData = responseData[Constants.RESPONSE_PARSING_RESULT] else {
                            return
                        }
                        
                        if let responseArray = resultsData as? [[String: AnyObject]] {
                            var modelData: [DataModel] = [DataModel]()
                            
                            for model in responseArray {
                                
                                let dataModel = DataModel(dict: model)
                                DispatchQueue.global(qos: .background).async(execute: {
                                    self?.getResponseForImage(dataModel: dataModel, completionHandler: { (image, error) in
                                        DispatchQueue.global().async {
                                            if let image = image {
                                                dataModel.image = image
                                                DispatchQueue.main.async {
                                                    SwiftSpinner.hide()
                                                    NotificationCenter.default.post(name: Notifications.myNotification.name, object: nil)
                                                }
                                            }
                                            
                                        }
                                    })
                                    modelData.append(dataModel)
                                    
                                })
                                
                                
                            }
                            
                            completionHandler(modelData, nil)
                        }
                    }
                        
                    catch let responseDataError {
                        completionHandler(nil, responseDataError)
                    }
                }
                
            }
        }
    }
    
    func getImageFrom(imageURL: String, completionHandler: @escaping (UIImage?, Error?) -> Void){
        let fullPath = Constants.BASE_IMAGE_URL+imageURL
        
        if let fullPath = fullPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let request = URLRequest(url: URL(string: fullPath)!)
            
            getRequest(path: request, completionHandler: { data, error in
                /// Handling error handling scenario's
                if error != nil {
                    completionHandler(nil, error)
                }
                    
                else {
                    guard let data = data else{
                        completionHandler(UIImage(named: "no_Img"), nil)
                        return
                    }
                    
                    completionHandler(UIImage(data: data), nil)
                    
                }
                
            })
        }
    }
    
    func getResponseForImage(dataModel: DataModel, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        
        if let image = dataModel.poster_path {
            self.getImageFrom(imageURL: image, completionHandler: { data, error in
                guard let data = data else{
                    completionHandler(UIImage(named: "no_Img"), nil)
                    return
                }
                
                completionHandler(data, nil)
            })
        }
    }
}
