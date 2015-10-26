//
//  ViewController.swift
//  slicktv
//
//  Created by Stanley Chiang on 9/29/15.
//  Copyright (c) 2015 Stanley Chiang. All rights reserved.
//

import UIKit
import MediaPlayer
import Alamofire

class ViewController: UIViewController,linkDelegate {

    @IBOutlet weak var textURL: UITextField!
    let player:MPMoviePlayerController = MPMoviePlayerController()
    var video:videoStreamer?
    var myshow:tvshow?
    var fullSourceLink:String!
    var sourceDom:String!
    let tvmuseAJAX:String = "http://www.tvmuse.com/ajax.php"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textURL.text = "Rick-and-Morty_35955"
        
        myshow = tvshow(name: textURL.text, season: 1, episode: 1)
        
        fullSourceLink = rawLinkSource(show: myshow!,source: "tvmuse").fullLink

//        load fullSourceLink dom
        Network.sharedInstance.getEpisodePage(fullSourceLink,
            success: { (response) -> Void in

//        extract and return div_com_(\\d*)\\D id values
                let re = NSRegularExpression(pattern: "div_com_(\\d*)\\D", options: nil, error: nil)!
                let matches = re.matchesInString(response, options: nil, range: NSRange(location: 0, length: count(response.utf16)))
                var postResponse:String?
                var done = false
                for match in matches as! [NSTextCheckingResult] {
                    if done {
                        break
                    }else{
                        // range at index 0: full match
                        // range at index 1: first capture group
                        let substring = (response as NSString).substringWithRange(match.rangeAtIndex(1))
                        println(substring as String)
                        
                        //        send post request as built below
                        //        curl --data "action=2h&sri=0.6509881792590022&o_item0=1814081" "http://www.tvmuse.com/ajax.php"
                        var tvmuseParams:[String : AnyObject] = [
                            "action":"2h",
                            "o_item0":substring
                        ]
                        Network.sharedInstance.getHostLink(self.tvmuseAJAX, params: tvmuseParams,
                            success: { (response) -> Void in
                                postResponse = response
                                println(postResponse)
//                            how do I stop the for loop from here if i have what i need?
//                            start extracting host links with /(http.*vodlocker\.com\/[[:alnum:]]*?)/U
                                var pattern = "(http.*vodlocker\\.com\\/.*?)[^a-zA-Z0-9]"
                                var hostLink:String = self.extractText(pattern, mytext: self.extractText(pattern, mytext: postResponse!))
                                println(hostLink)
                                done = true
                            },failure:
                            { (error) -> Void in
                                println(error)
                        })
                    }
                }
            }) { (error) -> Void in
                println(error)
        }
        
        textURL.text = "http://vodlocker.com/82vqdnh0s9ow"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "doneButtonClick:", name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "movieOrientationChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    func loadVideo(link: NSURL){
        player.view.frame = self.view.bounds
        player.movieSourceType = MPMovieSourceType.Streaming
        player.controlStyle = MPMovieControlStyle.Embedded
        player.scalingMode = MPMovieScalingMode.AspectFit
        player.contentURL = link
        player.prepareToPlay()

        self.tabBarController?.tabBar.hidden = true
        self.view.addSubview(player.view)
        player.play()
    }
    
    @IBAction func goButtonPressed(sender: UIButton) {
        //initializing a video streamer creates an object that then contains the embedded video nsurl
        
        video = videoStreamer(url: textURL.text)
        video?.delegate = self
        self.view.addSubview(video!)
        textURL.resignFirstResponder()
    }
    
    func didfinish(link: NSURL) {
        loadVideo(link)
    }
    
    func movieOrientationChanged(sender:NSNotification?) {
        player.view.frame = self.view.bounds
    }
    
    func doneButtonClick(sender:NSNotification?){
        player.stop()
        player.view.removeFromSuperview()
        self.tabBarController?.tabBar.hidden = false
    }
    
    func extractText(myPattern:String,mytext:String)->(String) {
        let re2 = NSRegularExpression(pattern: myPattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!
        let matches2 = re2.matchesInString(mytext, options: nil, range: NSRange(location: 0, length: count(mytext.utf16)))
        for match in matches2 as! [NSTextCheckingResult] {
            // range at index 0: full match
            // range at index 1: first capture group
            return (mytext as NSString).substringWithRange(match.rangeAtIndex(1)) as String
        }
        return ""
    }
}