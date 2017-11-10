//
//  Temp.swift
//  mapProject
//
//  Created by Андрей Илалов on 19.07.17.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

class Temp: Object{
    dynamic var latitude = Double()
    dynamic var longitude = Double()
    dynamic var pace = Double()
    dynamic var time = TimeInterval()
    
}
