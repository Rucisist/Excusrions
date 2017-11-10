//
//  ThePin.swift
//  mapProject
//
//  Created by Андрей Илалов on 26.07.17.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import Foundation
import MapKit


class ThePin: NSObject, MKAnnotation {
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    var title: String?
    var theNameOfRecord: URL!
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
