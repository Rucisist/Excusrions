//
//  RecordData.swift
//  mapProject
//
//  Created by Андрей Илалов on 26.07.17.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import Foundation
import RealmSwift

class RecordData: Object{
    dynamic var nameOfFile: String = " "
    dynamic var date: String = " "
    var theListOfCoords = List<CoordsTempRecord>()
    
    override static func primaryKey() -> String?{
        return "nameOfFile"
    }
}
