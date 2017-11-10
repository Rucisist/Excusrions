//
//  CoordsTempRecord.swift
//  mapProject
//
//  Created by Андрей Илалов on 26.07.17.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import Foundation
import RealmSwift

class CoordsTempRecord: Object {
    dynamic var longitude = Double()
    dynamic var lattitude = Double()
}
