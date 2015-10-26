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
                for match in matches as! [NSTextCheckingResult] {
                    // range at index 0: full match
                    // range at index 1: first capture group
                    let substring = (response as NSString).substringWithRange(match.rangeAtIndex(1))
                    println(substring)
                }
            }) { (error) -> Void in
                println(error)
        }
        
//        send post request as built below
//        extract usable links into array
//        try extracting videos from links
        
//        curl --data "action=2h&sri=0.6509881792590022&o_item0=1814081" "http://www.tvmuse.com/ajax.php"
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
}