//
//  ShowView.swift
//  slicktv
//
//  Created by Stanley Chiang on 5/4/16.
//  Copyright © 2016 Stanley Chiang. All rights reserved.
//

import UIKit

class ShowView: UIView {

    var episodeList = UITableView()
    
    func loadView(){
        backgroundColor = UIColor.greenColor()
        
        episodeList = addEpisodeList()
        addSubview(episodeList)
        print(episodeList.frame)
    }
    
    func addEpisodeList() -> UITableView {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.frame = CGRectMake(10, 10, frame.width - 20, frame.height - 20)
        print(tableView.frame)
        tableView.backgroundColor = UIColor.lightGrayColor()
        return UITableView()
    }
}
