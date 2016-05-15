//
//  ShowModel.swift
//  slicktv
//
//  Created by Stanley Chiang on 5/4/16.
//  Copyright © 2016 Stanley Chiang. All rights reserved.
//

import Foundation
import SwiftyJSON

class ShowModel: NSObject {
    var showObject:JSON = nil
    var showSchedule:JSON = nil
    
    override init() {
        super.init()
    }
    
}