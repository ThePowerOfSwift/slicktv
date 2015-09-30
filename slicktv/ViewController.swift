//
//  ViewController.swift
//  slicktv
//
//  Created by Stanley Chiang on 9/29/15.
//  Copyright (c) 2015 Stanley Chiang. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var textURL: UITextField!
    @IBOutlet weak var webView: UIWebView!
    var link = ""
    let player:MPMoviePlayerController = MPMoviePlayerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        webView!.delegate = self
        loadLink("https://google.com")
        textURL.text = "http://vodlocker.com/vzxb56qffdf4"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "doneButtonClick:", name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
    }

//    link must be fully formatted with 'http://'
    func loadLink(link: String){
        var url = NSURL(string: link)
        var request = NSURLRequest(URL: url!)
        webView!.loadRequest(request)
    }

    func loadVideo(link: String){
        var url = NSURL(string: link)
        
        player.view.frame = self.view.bounds
        self.view.addSubview(player.view)
        
        player.movieSourceType = MPMovieSourceType.Streaming
        player.controlStyle = MPMovieControlStyle.Fullscreen
        player.scalingMode = MPMovieScalingMode.AspectFill
        player.contentURL = url!
        player.prepareToPlay()
        player.play()
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
    
    @IBAction func goButtonPressed(sender: UIButton) {
        loadLink(textURL.text)
        textURL.resignFirstResponder()
    }
    
    func doneButtonClick(sender:NSNotification?){
        player.stop()
        player.view.removeFromSuperview()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        var dom = webView.stringByEvaluatingJavaScriptFromString("document.documentElement.innerHTML")!
        
        var matchesVodlocker = matchesForRegexInText("\"(.+v\\.mp4)", text: dom)
        if link == "" && matchesVodlocker != [] && matchesVodlocker[0] != "" {
            link = dropFirst(matchesVodlocker[0])
            loadVideo(link)
        }

//        var matchesAllMyVideos = matchesForRegexInText("\"file\" : \"(.+v2)", text: dom)
//        if link == "" && matchesAllMyVideos != [] && matchesAllMyVideos[0] != "" {
//            link = dropFirst(matchesAllMyVideos[0])
//            self.performSegueWithIdentifier("foundLink", sender: self)
//        }

    }

}

