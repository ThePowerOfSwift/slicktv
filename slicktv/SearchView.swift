//
//  SearchView.swift
//  slicktv
//
//  Created by Stanley Chiang on 4/24/16.
//  Copyright © 2016 Stanley Chiang. All rights reserved.
//

import UIKit

protocol searchDelegate {
    func getNavBarHeight() -> CGFloat
    func getTabBarHeight() -> CGFloat
    func searchTapped(searchText: String)
}

class SearchView: UIView {
    
    var delegate:searchDelegate?
    
    var searchBar = UIView()
    var searchField = UITextField()
    var searchButton = UIButton()
    
    let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
    
    var resultsList = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadView(){
        
        backgroundColor = UIColor.orangeColor()
        
//        add search bar to view underneath nav bar
        searchBar = addSearchBar()
        addSubview(searchBar)
        
//        add search field to search bar
        searchField = addSearchField()
        searchBar.addSubview(searchField)
        
//        add search button to search bar
        searchButton = addSearchButton()
        searchBar.addSubview(searchButton)
        
//        add table view area for search results
        resultsList = addResultsList()
        addSubview(resultsList)
        
//        preload search results with hard coded list of favorites
    }
    
    func addSearchBar() -> UIView {
        let view = UIView()
        let navBarHeight = delegate?.getNavBarHeight()
        view.frame = CGRectMake(0,navBarHeight! + statusBarHeight,frame.width, frame.height/10)
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
        button.addTarget(self, action: #selector(SearchView.searchTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        button.setTitle("Search", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.blueColor()
        return button
    }
    
    func searchTapped(sender: UIButton) {
        delegate?.searchTapped(searchField.text!)
    }
    
    func addResultsList() -> UITableView {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        
        let bottomOfSearchBarY = searchBar.frame.origin.y + searchBar.frame.height
        
        tableView.frame = CGRectMake(0, bottomOfSearchBarY, frame.width, frame.height - bottomOfSearchBarY - (delegate?.getTabBarHeight())!)
        return tableView
    }
}
