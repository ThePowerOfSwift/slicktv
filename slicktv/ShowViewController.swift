//
//  ShowViewController.swift
//  slicktv
//
//  Created by Stanley Chiang on 5/4/16.
//  Copyright © 2016 Stanley Chiang. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShowViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,showDelegate {

    var showView = ShowView()
    var show = ShowModel()
    var results = ["qqq","www","eee"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showView.frame = view.frame
        showView.loadView()
        self.view.addSubview(showView)
        
        show.delegate = self
        retrieveMostRecentEpisode()
        
        print("showviewframe \(showView.episodeList.frame)")
        
        showView.episodeList.delegate = self
        showView.episodeList.dataSource = self
//        showView.episodeList.frame = view.frame
        showView.episodeList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "showCell")
        print(show.showObject["name"].string!)
    }
    
    func retrieveMostRecentEpisode(){
        show.getMostRecentEpisode(show.showObject["id"].int!)
    }
    
    func mostRecentEpisode(result: JSON) {
        print(result["_links"]["previousepisode"]["href"].string!)
        show.convertEpisodeLinkToEpisodeNumber(result["_links"]["previousepisode"]["href"].string!)
    }
    
    func episodeData(result: JSON) {
        print(result["id"])
        print(result["season"])
        print(result["number"])
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = showView.episodeList.dequeueReusableCellWithIdentifier("showCell")! as UITableViewCell
        cell.textLabel!.text = results[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        return print(indexPath.row)
    }
}
