//
//  SearchViewController.swift
//  slicktv
//
//  Created by Stanley Chiang on 4/23/16.
//  Copyright © 2016 Stanley Chiang. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, searchDelegate, queryDelegate {

    let searchView = SearchView()
    var results: Array = [JSON]()
    let search = SearchModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.delegate = self
        
        searchView.delegate = self
        searchView.frame = view.frame
        searchView.loadView()
        self.view.addSubview(searchView)
        
        searchView.resultsList.delegate = self
        searchView.resultsList.dataSource = self
        searchView.resultsList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")    
    }
    
    func searchTapped(searchText: String) {
        search.forTVShow(searchText)
    }
    
    func searchCompleted(results: Array<JSON>) {
        self.results.removeAll()
        
//        how do i do error handling while i do the map function?
        self.results = results
        
        if self.results.count == 0 {
            self.results.append("no results found")
        }
        
        self.searchView.resultsList.reloadData()
    }
    
    func getNavBarHeight() -> CGFloat {
        return (self.navigationController?.navigationBar.frame.height)!
    }
    
    func getTabBarHeight() -> CGFloat {
        return (self.tabBarController?.tabBar.frame.height)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = searchView.resultsList.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel!.text = results[indexPath.row]["name"].string!
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("tapped on: \(results[indexPath.row]["id"].int!)")
        
//        segue to tv show detail which will include show schedule and actions like bookmark or watch latest episode
        let vc = ShowViewController()
        vc.show.showObject = results[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
