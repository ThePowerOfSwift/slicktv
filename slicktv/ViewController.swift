//
//  ViewController.swift
//  slicktv
//
//  Created by Stanley Chiang on 9/29/15.
//  Copyright (c) 2015 Stanley Chiang. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {

    @IBOutlet weak var textURL: UITextField!
    let player:MPMoviePlayerController = MPMoviePlayerController()
    var video:videoStreamer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textURL.text = "http://vodlocker.com/vzxb56qffdf4"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "doneButtonClick:", name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
    }

    func loadVideo(link: NSURL){
        player.view.frame = self.view.bounds
        player.movieSourceType = MPMovieSourceType.Streaming
        player.controlStyle = MPMovieControlStyle.Fullscreen
        player.scalingMode = MPMovieScalingMode.AspectFill
        player.contentURL = link
        player.prepareToPlay()

        self.tabBarController?.tabBar.hidden = true
        self.view.addSubview(player.view)
        player.play()
    }
    
    @IBAction func goButtonPressed(sender: UIButton) {
        //initializing a video streamer creates an object that then contains the embedded video nsurl
        
        getVideo(textURL.text, useExtractedLink: { (extractedLink:NSURL) -> () in
                println("VC")
                println(extractedLink)
                self.loadVideo(extractedLink)
        })
    }
    
    func getVideo(url:String, useExtractedLink:(extractedLink:NSURL)-> ()){
        video = videoStreamer(url: textURL.text)
        self.view.addSubview(video!)
        textURL.resignFirstResponder()
    }
    
    
    
    func doneButtonClick(sender:NSNotification?){
        player.stop()
        player.view.removeFromSuperview()
        self.tabBarController?.tabBar.hidden = false
    }
}