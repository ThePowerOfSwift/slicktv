//
//  videoStreamer.swift
//  slicktv
//
//  Created by Stanley Chiang on 10/5/15.
//  Copyright (c) 2015 Stanley Chiang. All rights reserved.
//

import UIKit

protocol linkDelegate{
    func didfinish(link:NSURL)
}

class videoStreamer:UIView, UIWebViewDelegate{

    var delegate:linkDelegate?
    var webView: UIWebView? = UIWebView(frame: CGRectMake(0, 0, 0, 0))
    var embeddedLink: NSURL?
    
    init(url:String){
        super.init(frame: CGRectMake(0, 0, 0, 0))
        self.addSubview(webView!)
        //this takes the url string and makes a web request
        loadLink(url)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //    link must be fully formatted with 'http://'
    func loadLink(link: String){
        let url = NSURL(string: link)
        let request = NSURLRequest(URL: url!)
        webView?.delegate = self
        webView?.hidden = true

        //request goes to webViewDidFinishLoad
        webView!.loadRequest(request)
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        //get dom of request
        if !webView.loading{
            let dom:String = webView.stringByEvaluatingJavaScriptFromString("document.documentElement.innerHTML")!
            let link:String = (webView.request?.URL?.absoluteString)!
            
            if let embeddedVideo:String = extractVideo(link,dom: dom){
                //have a function that parses doms based on the domain and return the link to the embedded video
                embeddedLink = NSURL(string: embeddedVideo)
                delegate?.didfinish(embeddedLink!)
            }
        }
    }
   
    func extractVideo(link:String, dom:String) -> String? {
        //first classify link
        let classified = classify(link)
        
        //then extract the video
        return extractor(hoster: classified, dom: dom).link
    }
    
    func classify(link:String) -> host{

        if let match = link.rangeOfString("vodlocker", options: .RegularExpressionSearch){
            return host.vodlocker
        }
        if let match = link.rangeOfString("allmyvideos", options: .RegularExpressionSearch){
            return host.allmyvideos
        }
        return host.none
    }
    

}