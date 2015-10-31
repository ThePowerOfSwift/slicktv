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
        let regex:String? = streamer.rawValue
        if let _regex = regex {
            var matches = matchesForRegexInText(_regex, text: dom)
            if link == nil && matches != [] && matches[0] != "" {
                link = String(matches[0].characters.dropFirst())
                return link!
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
    
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        let regex = try! NSRegularExpression(pattern: regex,
            options: [])
        let nsString = text as NSString
        let results = regex.matchesInString(text,
            options: [], range: NSMakeRange(0, nsString.length))
            
        return results.map { nsString.substringWithRange($0.range)}
    }
    
    //find all that match
    func regexMatches(pattern: String, text: String) -> Array<String> {
        let re = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = re.matchesInString(text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        
        var collectMatches: Array<String> = []
        for match in matches {
            // range at index 0: full match
            // range at index 1: first capture group
            let substring = (text as NSString).substringWithRange(match.rangeAtIndex(1))
            collectMatches.append(substring)
        }
        return collectMatches
    }
    
}