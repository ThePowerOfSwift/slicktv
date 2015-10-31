//
//  network.swift
//  slicktv
//
//  Created by Stanley Chiang on 10/24/15.
//  Copyright (c) 2015 Stanley Chiang. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class Network {
    static let sharedInstance = Network()
    private init() {}
    
    func getEpisodePage(link:String, success:(response:String)->Void,failure:(error:AnyObject)->Void) {
        Alamofire.request(.GET, link)
            .responseString { response in
                if response.result.isSuccess {
                    success(response: response.result.value!)
                }else{
                    failure(error: response.result.error!)
                }
        }
    }
    
    func getHostPage(link:String, success:(response:String)->Void,failure:(error:AnyObject)->Void) {
        let headers = [
            "User-Agent": "Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25",
        ]
        Alamofire.request(.GET, link, headers:headers)
            .responseString { response in
                if response.result.isSuccess {
                    success(response: response.result.value!)
                }else{
                    failure(error: response.result.error!)
                }
        }
    }

    func getHostLink(link:String,params: [String: AnyObject], success:(response:String)->Void,failure:(error:AnyObject)->Void) {
        Alamofire.request(.POST, link, parameters:params)
            .responseString { response in
                if response.result.isSuccess {
                    success(response: response.result.value!)
                }else{
                    failure(error: response.result.error!)
                }
        }
    }

}