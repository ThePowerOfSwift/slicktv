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
import PromiseKit

class ViewController: UIViewController,linkDelegate {

    @IBOutlet weak var textURL: UITextField!
    let player:MPMoviePlayerController = MPMoviePlayerController()
    var video:videoStreamer?
    var myshow:tvshow?
    var fullSourceLink:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textURL.text = "Rick-and-Morty_35955"
        
        myshow = tvshow(name: textURL.text!, season: 1, episode: 1)
        
        fullSourceLink = rawLinkSource(show: myshow!,source: "tvmuse").fullLink

        Network.sharedInstance.makePromiseRequest(.GET, url: NSURL(string: fullSourceLink)! ).then {  (idArray) -> Promise<AnyObject> in
                let id = idArray as! [String]
                return Network.sharedInstance.makePromiseRequestHostLink(.POST, id: id[0])
        }.then { (vodlockerLink) -> Void in
            self.textURL.text = vodlockerLink as? String
//            self.textURL.text = "http://vodlocker.com/82vqdnh0s9ow"
        }
        

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
        
        video = videoStreamer(url: textURL.text!)
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
        let re2 = try! NSRegularExpression(pattern: myPattern, options: NSRegularExpressionOptions.CaseInsensitive)
        let matches2 = re2.matchesInString(mytext, options: [], range: NSRange(location: 0, length: mytext.utf16.count))
        for match in matches2 {
            // range at index 0: full match
            // range at index 1: first capture group
            return (mytext as NSString).substringWithRange(match.rangeAtIndex(1)) as String
        }
        return ""
    }
    
    func getHostPage(){
        Network.sharedInstance.getHostPage("http://vodlocker.com/82vqdnh0s9ow", success: { (response) -> Void in
                print("success: \(response)")
            }) { (error) -> Void in
                print("error: \(error)")
        }
    }
}