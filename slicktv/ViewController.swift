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
//        textURL.text = "http://vodlocker.com/82vqdnh0s9ow"
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
        
        myshow = tvshow(name: textURL.text!, season: 1, episode: 1)
        
        fullSourceLink = rawLinkSource(show: myshow!,source: "tvmuse").fullLink
        
        Network.sharedInstance.makePromiseRequest(.GET, url: NSURL(string: fullSourceLink)! )
        .then {  (idArray) -> Promise<AnyObject> in
            let ids = idArray as! [String]
//                var value = Network.sharedInstance.makePromiseRequestHostLink(.POST, id: ids[0])
            var p:Promise<AnyObject>!
//                need to loop through the ids until a vodlocker link is found
            for item in ids {
//                    value = Network.sharedInstance.makePromiseRequestHostLink(.POST, id: item)
                p = p.then{ _ in
                    return Network.sharedInstance.makePromiseRequestHostLink(.POST, id: item)
                }
            }
            return Promise { fulfill, reject in
                let done = "done"
                fulfill(done)
            }
        }.then { (vodlockerLink) -> Void in
            self.video = videoStreamer(url: (vodlockerLink as? String)!)
            self.video?.delegate = self
            self.view.addSubview(self.video!)
            self.textURL.resignFirstResponder()
        }
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