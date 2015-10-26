//
//  network.swift
//  slicktv
//
//  Created by Stanley Chiang on 10/24/15.
//  Copyright (c) 2015 Stanley Chiang. All rights reserved.
//

import Foundation
import Alamofire

class Network {
    static let sharedInstance = Network()
    private init() {}
    
    func getEpisodePage(link:String, success:(response:String)->Void,failure:(error:AnyObject)->Void) {
        Alamofire.request(.GET, link)
            .responseString { response in
                if let _response = response.2 {
                    success(response: _response as String)
                }else if let _error = response.3{
                    failure(error: _error)
                }
        }
    }

    func getHostLink(link:String,params: [String: AnyObject], success:(response:String)->Void,failure:(error:AnyObject)->Void) {
        Alamofire.request(.POST, link, parameters:params)
            .responseString { response in
                if let _response = response.2 {
                    success(response: _response as String)
                }else if let _error = response.3{
                    failure(error: _error)
                }
        }
    }

}