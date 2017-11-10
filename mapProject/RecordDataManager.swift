//
//  RecordDataManager.swift
//  mapProject
//
//  Created by Андрей Илалов on 26.07.17.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import Foundation
import RealmSwift

class RecordDataManager {
    func saveRecord(theNameOfFile: String, date: String, longitude: [Double], lattitude: [Double]){
        let record = RecordData()
        record.nameOfFile = theNameOfFile
        record.date = date
        let realm = try! Realm()
        var i = 0
        while i < longitude.count{
            let tmp = CoordsTempRecord()
            tmp.longitude = longitude[i]
            tmp.lattitude = lattitude[i]
            record.theListOfCoords.append(tmp)
            i+=1
        }
        
        try! realm.write {
            realm.add(record, update: true)
        }
        
    }
    
    func loadRecordsDB (theNameOfFile: String) -> Results<RecordData>{
        let realm = try! Realm()
        let data = realm.objects(RecordData.self).filter("nameOfFile BEGINSWITH %@", theNameOfFile)
        return data
        
    }
    
    func loadListOfRecords () -> [String] {
        let realm = try! Realm()
        var listOfRecords: [String] = []
        for value in realm.objects(RecordData.self){
            listOfRecords.append(value.nameOfFile)
        }
        return listOfRecords
    }
    
    
}
