//
//  mapViewController.swift
//  mapProject
//
//  Created by Андрей Илалов on 21.07.17.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift
import AVFoundation
import CoreLocation

class mapViewController: UIViewController, AVAudioRecorderDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var map: MKMapView!
    
    
    private var locationList: [CLLocation] = []
    var locationManager = CLLocationManager()
    var flag: Bool = false
    var counter: Int = 0
    var theNameOfRecord: String = ""
    
    @IBAction func pinThePointsOnTheMap(_ sender: Any) {
        pinPoints()
    }
    @IBAction func record(_ sender: Any) {
        
        
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        
                    } else {
                        
                    }
                }
            }
        } catch {
            
            
            
            
        }
        
        flag = true
        
        startRecording()

        
        
    }
    var audioURL: URL!

    @IBAction func play(_ sender: Any) {
        //audioURL = mapViewController.getWhistleURL()
        let recordDataManager = RecordDataManager()
        let name = recordDataManager.loadListOfRecords().last
        let data = recordDataManager.loadRecordsDB(theNameOfFile: name!)
        let nameOfFile = data[0].nameOfFile
        

        
        let audioURL1 = mapViewController.getDocumentsDirectory().appendingPathComponent(nameOfFile)
        
        print("the URL IS")
        print(audioURL1)
        
        
        
        if (audioURL != nil) {
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        try!  audioPlayer = AVAudioPlayer(contentsOf: audioURL1)
        audioPlayer!.prepareToPlay()
        audioPlayer?.play()
        }
        
        print(recordDataManager.loadListOfRecords())
        
    }
    @IBAction func stop(_ sender: Any) {
        
        
        whistleRecorder.stop()
        whistleRecorder = nil
        flag = false
        let dataManger = RecordDataManager()
        let date = Date()
        var lat: [Double] = []
        var lon: [Double] = []
        for i in locationList{
            lat.append(Double(i.coordinate.latitude))
            lon.append(Double(i.coordinate.longitude))
        }

        print(lon)
        
        dataManger.saveRecord(theNameOfFile: theNameOfRecord, date: String(describing: date), longitude: lon, lattitude: lat)
        locationList = []
        let recordDataManager = RecordDataManager()
        print(recordDataManager.loadListOfRecords())
        print(String(describing: audioURL))
        
    }
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 1
        locationManager.startUpdatingLocation()
    }

    
    
    @IBAction func showonmap(_ sender: Any) {
    }
    
    var nameOfrun: String = ""
    var dataManger = DataManager()
    
    
    var recordingSession: AVAudioSession!
    var whistleRecorder: AVAudioRecorder!
    private var audioPlayer: AVAudioPlayer?
    
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    class func getWhistleURL() -> URL {
        let date = Date()

        return getDocumentsDirectory().appendingPathComponent("whistle.m4a")
    }
    
     func getDownloadURL() -> URL {
        
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd-MM-yyyy_HH:mm:ss"
        let prefix = dateFormat.string(from: date)
        
        let recordDataManager = RecordDataManager()
//        let name = recordDataManager.loadListOfRecords()[1]
//        let data = recordDataManager.loadRecordsDB(theNameOfFile: name)
        counter=counter+1
        print(prefix)
        theNameOfRecord = prefix+"whistle.m4a"
        return mapViewController.getDocumentsDirectory().appendingPathComponent(prefix+"whistle.m4a")
    }
    func getDownloadURL1() -> URL {
        let recordDataManager = RecordDataManager()
        let name = recordDataManager.loadListOfRecords()[1]
        let data = recordDataManager.loadRecordsDB(theNameOfFile: name)
        return mapViewController.getDocumentsDirectory().appendingPathComponent(String(counter)+"whistle.m4a")
    }

    
    
    
    func startRecording() {
        // 1
        //view.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
        
        // 2
        //recordButton.setTitle("Tap to Stop", for: .normal)
        
        // 3
        audioURL = mapViewController.getWhistleURL()
        audioURL = getDownloadURL()
        print(audioURL.absoluteString)
        
        // 4
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            // 5
            whistleRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            whistleRecorder.delegate = self
            whistleRecorder.record()
        } catch {
            print(" ")
        }
    }

    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            
            if flag {
            //let howRecent = newLocation.timestamp.timeIntervalSinceNow
            //guard newLocation.horizontalAccuracy < 5 && abs(howRecent) < 5 else { continue }
            if let lastLocation = locationList.last {
            let x = MKMapCamera()
                x.centerCoordinate = (locationManager.location?.coordinate)!
                x.pitch = 10000
                    x.heading = newLocation.course
                    map.setCamera(x, animated: false)
                }
        
    
            print(newLocation.coordinate.latitude)
            
            locationList.append(newLocation)}
            
            
            
            guard let mostRecentLocation = locations.last else {
                return
            }
            
            // Add another annotation to the map.
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = mostRecentLocation.coordinate
            
            // Also add to our map so we can remove old values later
            //self.locations1.append(annotation)
            
            // Remove values if the array is too big
//            while locations.count > 100 {
//                let annotationToRemove = self.locations1.first!
//                self.locations1.remove(at: 0)
//                
//                // Also remove from the map
//                mapView.removeAnnotation(annotationToRemove)
//            }
//            
//            if UIApplication.shared.applicationState == .active {
//                mapView.showAnnotations(self.locations1, animated: true)
//            } else {
//                print("App is backgrounded. New location is %@", mostRecentLocation)
//            }
        
            
            
            
        }
        
    }

    
    
    func pinPoints(){
        let dataManager = RecordDataManager()
        let listOfRecord = dataManager.loadListOfRecords()
        print(listOfRecord.count)
        for i in listOfRecord{
            let data = dataManager.loadRecordsDB(theNameOfFile: i)[0].theListOfCoords[0]
            let longitude = CLLocationDegrees(data.longitude)
            let lattitude = CLLocationDegrees(data.lattitude)
            var an = MKPointAnnotation()
//            var annotations = []
//            annotations.append(an)
            var coordinate = CLLocationCoordinate2DMake(lattitude, longitude)
            var pin = ThePin(title: "hi", locationName: "log", discipline: "jhkjh", coordinate: coordinate)
            pin.theNameOfRecord = mapViewController.getDocumentsDirectory().appendingPathComponent(dataManager.loadRecordsDB(theNameOfFile: i)[0].nameOfFile)


            an.coordinate = coordinate
            an.title = "hi"
            an.subtitle = "dsfsdafhsdkjfhsdakfjhsdfkjsghfkasdjfgdkjfhjflhsdkghsdkjhfsdjkfsdfsdfsdfsdafd"
            map.addAnnotation(pin)
            
            
        }
    }
    
    
    
    func mapView(_ map: MKMapView!, viewFor annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? ThePin {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = map.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    
    
    var selectedAnnotation: ThePin?
    func mapView(_ map: MKMapView, didSelect view: MKAnnotationView) {
//        guard (selectedAnnotation != nil)
//            else {return}
        self.selectedAnnotation = (view.annotation as? ThePin)!
        print(selectedAnnotation?.theNameOfRecord ?? "n")
        audioURL = selectedAnnotation?.theNameOfRecord
        if (audioURL != nil) {
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try! AVAudioSession.sharedInstance().setActive(true)
            
            try!  audioPlayer = AVAudioPlayer(contentsOf: audioURL)
            audioPlayer!.prepareToPlay()
            audioPlayer?.play()
        }

        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print()
        //var t = dataManger.loadDB(runName: nameOfrun)
        //print(t[0].tempList.count)
        
        startLocationUpdates()
        map.delegate = self
        map.showsUserLocation = true
        print(locationManager.location?.coordinate.latitude)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    

    
    
    
    private func segmentColor(speed: Double, midSpeed: Double, slowestSpeed: Double, fastestSpeed: Double) -> UIColor {
        enum BaseColors {
            static let r_red: CGFloat = 1
            static let r_green: CGFloat = 20 / 255
            static let r_blue: CGFloat = 44 / 255
            
            static let y_red: CGFloat = 1
            static let y_green: CGFloat = 215 / 255
            static let y_blue: CGFloat = 0
            
            static let g_red: CGFloat = 0
            static let g_green: CGFloat = 146 / 255
            static let g_blue: CGFloat = 78 / 255
        }
        
        let red, green, blue: CGFloat
        
        if speed < midSpeed {
            let ratio = CGFloat((speed - slowestSpeed) / (midSpeed - slowestSpeed))
            red = BaseColors.r_red + ratio * (BaseColors.y_red - BaseColors.r_red)
            green = BaseColors.r_green + ratio * (BaseColors.y_green - BaseColors.r_green)
            blue = BaseColors.r_blue + ratio * (BaseColors.y_blue - BaseColors.r_blue)
        } else {
            let ratio = CGFloat((speed - midSpeed) / (fastestSpeed - midSpeed))
            red = BaseColors.y_red + ratio * (BaseColors.g_red - BaseColors.y_red)
            green = BaseColors.y_green + ratio * (BaseColors.g_green - BaseColors.y_green)
            blue = BaseColors.y_blue + ratio * (BaseColors.g_blue - BaseColors.y_blue)
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

    
    
    private func polyLine() -> [MulticolorPolyline] {
        
        // 1
        let locations =  locationList
        var coordinates: [(CLLocation, CLLocation)] = []
        var speeds: [Double] = []
        var minSpeed = Double.greatestFiniteMagnitude
        var maxSpeed = 0.0
        
        // 2
        for (first, second) in zip(locations, locations.dropFirst()) {
            let start = CLLocation(latitude: first.coordinate.latitude, longitude: first.coordinate.longitude)
            let end = CLLocation(latitude: second.coordinate.latitude, longitude: second.coordinate.longitude)
            coordinates.append((start, end))
            
            //3
            let distance = end.distance(from: start)
            let time = second.timestamp.timeIntervalSince(first.timestamp as Date)
            let speed = time > 0 ? distance / time : 0
            speeds.append(speed)
            minSpeed = min(minSpeed, speed)
            maxSpeed = max(maxSpeed, speed)
        }
        
        //4
        let midSpeed = speeds.reduce(0, +) / Double(speeds.count)
        
        //5
        var segments: [MulticolorPolyline] = []
        for ((start, end), speed) in zip(coordinates, speeds) {
            let coords = [start.coordinate, end.coordinate]
            let segment = MulticolorPolyline(coordinates: coords, count: 2)
            segment.color = segmentColor(speed: speed,
                                         midSpeed: midSpeed,
                                         slowestSpeed: minSpeed,
                                         fastestSpeed: maxSpeed)
            segments.append(segment)
        }
        return segments
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
