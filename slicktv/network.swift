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
import SwiftyJSON

class Network {
    static let sharedInstance = Network()
    private init() {}
    
    // Alamofire Request method with PromiseKit
    func makePromiseRequest(method: Alamofire.Method, url: NSURL) -> Promise<[String]> {
        return Promise { fulfill, reject in
            Alamofire.request(method, url).responseString { response in
            if response.result.isSuccess {
                    let re = try! NSRegularExpression(pattern: "div_com_(\\d*)\\D", options: [])
                    let res = response.result.value!
                    let matches = re.matchesInString(res, options: [], range: NSRange(location: 0, length: res.utf16.count))
                
                    fulfill(matches.map({(res as NSString).substringWithRange($0.rangeAtIndex(1))}))
                }else{
                    reject(response.result.error!)
                }
            }
        }
    }
    
    func makePromiseRequestHostLink(method: Alamofire.Method, id:String) -> Promise<AnyObject> {
        return Promise { fulfill, reject in
            var postResponse:String?
            let tvmuseAJAX:String = "http://www.tvmuse.com/ajax.php"
            let tvmuseParams:[String : AnyObject] = [
                "action":"2h",
                "o_item0":id
            ]

            Alamofire.request(method, tvmuseAJAX, parameters: tvmuseParams).responseString { response in
                if response.result.isSuccess {
                    postResponse = response.result.value
                    let pattern = "(http.*vodlocker\\.com\\/.*?)[^a-zA-Z0-9]"
                    let hostLink:String = self.extractText(pattern, mytext: self.extractText(pattern, mytext: postResponse!))
                    
                    fulfill(hostLink)
                }else{
                    reject(response.result.error!)
                }
            }
        }
    }
    
    func makePromiseQueryTVShow(method: Alamofire.Method, url:String) -> Promise<AnyObject> {
        return Promise { fulfill, reject in
            let encodedTVShow:String = "http://api.tvmaze.com/singlesearch/shows?q=\((url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet()))!)"
            
            Alamofire.request(method, encodedTVShow).responseJSON { response in
                if response.result.isSuccess {
                    fulfill(response.result.value!)
                }else{
                    reject(response.result.error!)
                }
            }
        }
    }
    
    func makePromiseTVMazeEpisode(method: Alamofire.Method, url:String) -> Promise<JSON> {
        return Promise { fulfill, reject in
            let encodedEpisode:String = url
            
            Alamofire.request(method, encodedEpisode).responseJSON { response in
                if response.result.isSuccess {
                    fulfill(JSON(response.result.value!))
                }else{
                    reject(response.result.error!)
                }
            }
        }
    }
    
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

    func getHostLink(link:String,params: [String: AnyObject], success:(response:String)->String,failure:(error:AnyObject)->Void) {
        Alamofire.request(.POST, link, parameters:params)
            .responseString { response in
                if response.result.isSuccess {
                    success(response: response.result.value!)
                }else{
                    failure(error: response.result.error!)
                }
        }
    }

    func extractText(myPattern:String,mytext:String)->(String) {
        let re2 = try! NSRegularExpression(pattern: myPattern, options: NSRegularExpressionOptions.CaseInsensitive)
        let matches2 = re2.matchesInString(mytext, options: [], range: NSRange(location: 0, length: mytext.utf16.count))
        for match in matches2 {
            // range at index 0: full match
            // range at index 1: first capture group
            return (mytext as NSString).substringWithRange(match.rangeAtIndex(1)) as String
        }
        return ""
    }

}