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
    var tvmuseName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textURL.text = "arrow"

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
        self.textURL.resignFirstResponder()
        
        Network.sharedInstance.makePromiseQueryTVShow(.GET, url: textURL.text!).then{ (json) -> Promise<String> in
            
        self.showName = JSON(json)["name"].stringValue
        return Promise { fulfill, reject in
            fulfill(JSON(json)["_links"]["previousepisode"]["href"].stringValue)
        }
        }.then { (alink) -> Promise<JSON> in
            return Network.sharedInstance.makePromiseTVMazeEpisode(.GET, url: alink)
        }.then { (json) -> Promise<tvshow> in
            
            let showSeason = json["season"].stringValue
            let showNumber = json["number"].stringValue
            
            return Promise { fulfill, reject in
                
                let query:String = self.showName
                Network.sharedInstance.makePromiseRequestTVMuseSearch(.POST, tvmuseParams: ["action":"5","o_item0":query,"o_item1":"search_atc","o_item2":"search_atc_ul"]).then{
                    (name) -> Void in
                    
                    let tvmusename:String = name as! String
                    fulfill(tvshow(name: tvmusename, season: showSeason, episode: showNumber))
                }
            }
            
        }.then { (tvshow) -> Promise<[String]> in
            
            self.fullSourceLink = rawLinkSource(show: tvshow, source: "tvmuse").fullLink
            
            return Network.sharedInstance.makePromiseRequest(.GET, url: NSURL(string: self.fullSourceLink)! )
        
        }.then {  (idArray) -> Void in

            when(idArray.map({Network.sharedInstance.makePromiseRequestTVMuseAction(.POST, tvmuseParams: ["action":"2h","o_item0":$0])})).then{ link -> Promise<String> in
                return Promise { fulfill, reject in
                    let stringLink:[String] = link as! [String]
                    for entry in stringLink {
                        if entry != "" {
                            fulfill(entry)
                            break
                        }
                    }
                }
//                currently, we assume that the first vodlocker link we see is a good link
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