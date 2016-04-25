//
//  SearchViewController.swift
//  slicktv
//
//  Created by Stanley Chiang on 4/23/16.
//  Copyright © 2016 Stanley Chiang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, searchDelegate {

    let searchView = SearchView()
    
    var results = ["Arrow", "The Flash", "Blacklist"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.delegate = self
        searchView.frame = self.view.frame
        searchView.loadView()
        self.view.addSubview(searchView)
        
        searchView.resultsList.delegate = self
        searchView.resultsList.dataSource = self
        searchView.resultsList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")    
    }
    
    func searchTapped(searchText: String) {
        print("search: \(searchText)")
    }
    
    func getNavBarHeight() -> CGFloat {
        return (self.navigationController?.navigationBar.frame.height)!
    }
    
    func getTabBarHeight() -> CGFloat {
        return (self.tabBarController?.tabBar.frame.height)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = searchView.resultsList.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel!.text = results[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("tapped on: \(results[indexPath.row])")
    }
    
}
