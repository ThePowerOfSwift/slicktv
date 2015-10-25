//
//  rawLinkSource.swift
//  slicktv
//
//  Created by Stanley Chiang on 10/24/15.
//  Copyright (c) 2015 Stanley Chiang. All rights reserved.
//

import Foundation
import SwiftyJSON

class rawLinkSource {
    
    var fullLink:String
    init(show:tvshow, source:String){
        fullLink = "http://www.tvmuse.com/tv-shows/\(show.name)/season_\(show.season)/episode_\(show.episode)/"
    }
}