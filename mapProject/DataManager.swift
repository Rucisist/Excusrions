//
//  DataManager.swift
//  mapProject
//
//  Created by Андрей Илалов on 19.07.17.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit


class DataManager{
    
    func saveLoc (name: String, pace: [Double], latitude: [Double], longitude: [Double], time: [TimeInterval]){
        let realm = try! Realm()
        let theRun = RunData()
        theRun.RunName = name
        //tmp.coords = coords
        var i = 0
        while i < latitude.count{
        let tmp = Temp()
        tmp.latitude = latitude[i]
        tmp.longitude = longitude[i]
        tmp.pace = pace[i]
        tmp.time = time[i]
        //tmp.pace = 23.0
        theRun.tempList.append(tmp)
        i = i+1
        }
        
        try! realm.write {
            realm.add(theRun, update: true)
        }

    }
    
    func loadDB(runName: String) -> Results<RunData>  {
        let realm = try! Realm()
        let data = realm.objects(RunData.self).filter("RunName BEGINSWITH %@", runName)
        
        return data
    }
    
    func loadRunList() -> [String]{
        let realm = try! Realm()
        var list: [String] = []
        let data = realm.objects(RunData.self)
        for value in data {
           list.append(value.RunName)
        }
        return list
    }
    
    
}
