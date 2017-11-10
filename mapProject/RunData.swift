//
//  RunData.swift
//  mapProject
//
//  Created by Андрей Илалов on 19.07.17.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import Foundation
import RealmSwift

class RunData: Object {
    dynamic var RunName: String = " "
    var tempList = List<Temp>()
    
    override static func primaryKey() -> String? {
        return "RunName"
    }
    
}
