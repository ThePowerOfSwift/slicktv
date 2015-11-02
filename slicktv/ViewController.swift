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
import SwiftyJSON

class ViewController: UIViewController,linkDelegate {

    @IBOutlet weak var textURL: UITextField!
    let player:MPMoviePlayerController = MPMoviePlayerController()
    var video:videoStreamer?
    var myshow:tvshow?
    var fullSourceLink:String!

    var showName:String!
    var showSeason:String!
    var showNumber:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textURL.text = "rick and morty"
        
//        need to move this promise chain into button action chain and curl the tvmuse name
        Network.sharedInstance.makePromiseQueryTVShow(.GET, url: textURL.text!).then{
            (json) -> Promise<String> in
            
            self.showName = JSON(json)["name"].stringValue
            return Promise { fulfill, reject in
                fulfill(JSON(json)["_links"]["previousepisode"]["href"].stringValue)
            }
        }.then { (alink) -> Promise<JSON> in
            return Network.sharedInstance.makePromiseTVMazeEpisode(.GET, url: alink)
        }.then { (json) -> Void in
            self.showSeason = json["season"].stringValue
            self.showNumber = json["number"].stringValue
        }
        
//        textURL.text = "Rick-and-Morty_35955"
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

//    curl --data "action=5&o_item0=rick%20and%20morty&o_item1=search_atc&o_item2=search_atc_ul" "http://www.tvmuse.com/ajax.php"
    
    @IBAction func goButtonPressed(sender: UIButton) {
        self.textURL.resignFirstResponder()

        myshow = tvshow(name: "Rick-and-Morty_35955", season: 1, episode: 2)
        fullSourceLink = rawLinkSource(show: myshow!,source: "tvmuse").fullLink
        
        Network.sharedInstance.makePromiseRequest(.GET, url: NSURL(string: fullSourceLink)! )
        .then {  (idArray) -> Void in
            let ids = idArray as! [String]
            when(ids.map({Network.sharedInstance.makePromiseRequestHostLink(.POST, id: $0)})).then{ link -> Promise<String> in
                return Promise { fulfill, reject in
                    let stringLink:[String] = link as! [String]
                    for entry in stringLink {
                        if entry != "" {
                            fulfill(entry)
                            break
                        }
                    }
                }
            }.then { (vodlockerLink) -> Void in
                print(vodlockerLink)
                self.video = videoStreamer(url: vodlockerLink)
                self.video?.delegate = self
                self.view.addSubview(self.video!)
            }
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