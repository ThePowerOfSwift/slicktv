//
//  ShowViewController.swift
//  slicktv
//
//  Created by Stanley Chiang on 5/4/16.
//  Copyright © 2016 Stanley Chiang. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShowViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var showView = ShowView()
    var show = ShowModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showView.frame = view.frame
        showView.loadView()
        self.view.addSubview(showView)
        
        showView.episodeList.delegate = self
        showView.episodeList.dataSource = self
        showView.episodeList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        print(show.showObject["name"].string!)
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = showView.episodeList.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel!.text = "text"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        return print(indexPath.row)
    }
}
