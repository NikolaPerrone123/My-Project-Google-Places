//
//  APIClient.swift
//  My Project Google Places
//
//  Created by Nikola Popovic on 4/4/18.
//  Copyright © 2018 Nikola Popovic. All rights reserved.
//

import Foundation
import AFNetworking

class APIClient : AFHTTPSessionManager {
    class var sharedInstance : APIClient {
        struct Static {
            static let instance : APIClient = APIClient()
        }
        
        Static.instance.requestSerializer = AFHTTPRequestSerializer()
        Static.instance.responseSerializer = AFHTTPResponseSerializer()
        return Static.instance
    }
    
    func get(_ url : String, _ CompletionHandler:@escaping(_ code : Int,_ error : Error?,  _ response : Any?) -> Void){
        
        self.get(url, parameters: nil, progress: nil, success: { (operation : URLSessionDataTask, response) in
            do {
                let anyObj = try JSONSerialization.jsonObject(with: response as! Data, options: JSONSerialization.ReadingOptions.allowFragments)
                CompletionHandler(0, nil, anyObj)
            } catch {
                CompletionHandler(0, nil, nil)
            }
        }) { (operation : URLSessionDataTask?, error) in
            CompletionHandler(0, error, nil)
            print(error)
        }
    }
    
    func searchPlaces(CompletionHandler:@escaping(_ code : Int, _ error : Error?, _ response : Any?) -> Void) {
        self.get(searchUrl) { (code, error, response) in
            CompletionHandler(code, error, response)
        }
    }
}
