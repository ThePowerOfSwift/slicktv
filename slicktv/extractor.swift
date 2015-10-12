//
//  extractor.swift
//  slicktv
//
//  Created by Stanley Chiang on 10/6/15.
//  Copyright (c) 2015 Stanley Chiang. All rights reserved.
//

import Foundation

class extractor:NSObject{
    
    var link:String?
    var regex:String?

    //make it so that i pass the specific type of the host
    init(hoster:host,dom:String){
        super.init()
        videoExtractor(hoster,dom: dom)
    }
    
    func videoExtractor(streamer:host,dom:String) -> String? {

        if streamer == host.none{
            return nil
        }
        var regex:String? = streamer.rawValue
        if let _regex = regex {
            var matches = matchesForRegexInText(_regex, text: dom)
            if link == nil && matches != [] && matches[0] != "" {
                link = dropFirst(matches[0])
                return link!
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
    
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        let regex = NSRegularExpression(pattern: regex,
            options: nil, error: nil)!
        let nsString = text as NSString
        let results = regex.matchesInString(text,
            options: nil, range: NSMakeRange(0, nsString.length))
            as! [NSTextCheckingResult]
        return map(results) { nsString.substringWithRange($0.range)}
    }
    
}