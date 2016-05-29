//
//  ShowModel.swift
//  slicktv
//
//  Created by Stanley Chiang on 5/4/16.
//  Copyright © 2016 Stanley Chiang. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import SwiftyJSON

protocol showDelegate{
    func mostRecentEpisode(result:JSON)
    func episodeData(result:JSON)
}

class ShowModel: NSObject {
    var showObject:JSON = nil
    var showSchedule:JSON = nil
    
    var delegate:showDelegate?
    
    override init() {
        super.init()
    }

    func makePromiseGetMostRecentEpisode(showID:Int) -> Promise<AnyObject> {
        return Promise { fulfill, reject in
            let encodedTVShow:String = "http://api.tvmaze.com/shows/\(showID)"
            
            Alamofire.request(.GET, encodedTVShow).responseJSON { response in
                if response.result.isSuccess {
                    fulfill(response.result.value!)
                }else{
                    reject(response.result.error!)
                }
            }
        }
    }

    func makePromiseGetLast10Episodes(showID:Int, mostRecent:Int) -> Promise<AnyObject> {
        return Promise { fulfill, reject in
            let encodedTVShow:String = "http://api.tvmaze.com/shows/\(showID)"
            
            Alamofire.request(.GET, encodedTVShow).responseJSON { response in
                if response.result.isSuccess {
                    fulfill(response.result.value!)
                }else{
                    reject(response.result.error!)
                }
            }
        }
    }
    
    func makePromiseConvertEpisodeLinkToEpisodeNumber(link:String) -> Promise<AnyObject> {
        return Promise { fulfill, reject in
            let encodedTVShow:String = link
            
            Alamofire.request(.GET, encodedTVShow).responseJSON { response in
                if response.result.isSuccess {
                    fulfill(response.result.value!)
                }else{
                    reject(response.result.error!)
                }
            }
        }
    }
    
    func getMostRecentEpisode(showID:Int){
        makePromiseGetMostRecentEpisode(showID).then { (tvMazeMostRecentEpisode) -> Void in
            self.delegate?.mostRecentEpisode(JSON(tvMazeMostRecentEpisode))
        }
    }
    
    func convertEpisodeLinkToEpisodeNumber(episodeLink:String){
        makePromiseConvertEpisodeLinkToEpisodeNumber(episodeLink).then { (tvMazeEpisodeData) -> Void in
            self.delegate?.episodeData(JSON(tvMazeEpisodeData))
        }
    }
    
    func getLast10Episodes(showId:Int, mostRecent:Int){
        
    }
}