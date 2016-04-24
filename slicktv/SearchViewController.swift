//
//  SearchViewController.swift
//  slicktv
//
//  Created by Stanley Chiang on 4/23/16.
//  Copyright © 2016 Stanley Chiang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var searchBar = UIView()
    var searchField = UITextField()
    var searchButton = UIButton()
    
    let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
    
    var resultsList = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orangeColor()
        
//        add search bar to view underneath nav bar
        searchBar = addSearchBar()
        view.addSubview(searchBar)
        
//        add search field to search bar
        searchField = addSearchField()
        searchBar.addSubview(searchField)
        
//        add search button to search bar
        searchButton = addSearchButton()
        searchBar.addSubview(searchButton)
        
//        add table view area for search results
        resultsList = addResultsList()
        view.addSubview(resultsList)

//        preload search results with hard coded list of favorites
    
    }

    func addSearchBar() -> UIView {
        let view = UIView()
        let navBarHeight = (self.navigationController?.navigationBar.frame.height)!
        view.frame = CGRectMake(0,navBarHeight + statusBarHeight,self.view.frame.width, self.view.frame.height/10)
        view.backgroundColor = UIColor.brownColor()
        return view
    }
    
    func addSearchField() -> UITextField {
        let textField = UITextField()
        textField.frame = CGRectMake(0, 0, searchBar.frame.width * 4/5, searchBar.frame.height)
        textField.backgroundColor = UIColor.yellowColor()
        return textField
    }
    
    func addSearchButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRectMake(searchField.frame.width, 0, searchBar.frame.width * 1/5, searchBar.frame.height)
        button.addTarget(self, action: #selector(SearchViewController.searchTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        button.setTitle("Search", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.blueColor()
        return button
    }
    
    func searchTapped(sender: UIButton) {
        print("search: \(searchField.text!)")
    }
    
    func addResultsList() -> UITableView {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        let bottomOfSearchBarY = searchBar.frame.origin.y + searchBar.frame.height
        
        tableView.frame = CGRectMake(0, bottomOfSearchBarY, self.view.frame.width, self.view.frame.height - bottomOfSearchBarY - (self.tabBarController?.tabBar.frame.height)!)
        return tableView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("tapped: \(indexPath.row)")
    }
    
}
