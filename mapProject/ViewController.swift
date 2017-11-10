//
//  ViewController.swift
//  mapProject
//
//  Created by Андрей Илалов on 18.07.17.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var distanceLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
        //var locationManager = CLLocationManager()
    
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    
    
    
    //var timer  = Timer()
    var coords1: [CLLocationCoordinate2D] = []
   
    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let renderer = MKPolylineRenderer(overlay: overlay)
//        renderer.strokeColor = UIColor.red
//        renderer.lineWidth = 4
//        renderer.alpha=0.4
//        
//        return renderer
//    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MulticolorPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = polyline.color
        renderer.lineWidth = 3
        return renderer
    }
    
    

    @IBOutlet weak var stop: UIButton!
    
    @IBOutlet weak var start: UIButton!

    
    @IBAction func startRunOn(_ sender: Any) {
        stop.isHidden = false
        start.isHidden = true
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        startLocationUpdates()
        
        
//        timer = Timer.scheduledTimer(timeInterval: 1,
//                                     target: self,
//                                     selector: #selector(self.timerdo(timer:)),
//                                     userInfo: nil,
//                                     repeats: true)
        
        //timer.fire()
    }
    
    func stoppingRun() {
        start.isHidden = false
        stop.isHidden = true
        timer?.invalidate()
    }
    
    @IBAction func stopRun(_ sender: Any) {
//        start.isHidden = false
//        stop.isHidden = true
//        timer?.invalidate()
        var manage = DataManager()
        var pace = [20.0,34.0,24.0]
        var lat: [Double] = []
        var lon: [Double] = []
        
        
        
        
        var minSpeed = Double.greatestFiniteMagnitude
        var maxSpeed = 0.0
        var locations = locationList
        var coordinates: [(CLLocation, CLLocation)] = []
        var times: [TimeInterval] = []
        var speeds: [Double] = []
        var paces: [Double] = []
        // 2
        for (first, second) in zip(locations, locations.dropFirst()) {
            let start = CLLocation(latitude: first.coordinate.latitude, longitude: first.coordinate.longitude)
            let end = CLLocation(latitude: second.coordinate.latitude, longitude: second.coordinate.longitude)
            coordinates.append((start, end))
            
            //3
            

            let distance = end.distance(from: start)
            let time = second.timestamp.timeIntervalSince(first.timestamp as Date)
            times.append(time)
            let speed = time > 0 ? distance / time : 0
            speeds.append(speed)
            paces.append(1/(speed+0.002))
            minSpeed = min(minSpeed, speed)
            maxSpeed = max(maxSpeed, speed)
        }
        
        //4
            let midSpeed = speeds.reduce(0, +) / Double(speeds.count)

        
        
        
        for i in locations{
            lat.append(Double(i.coordinate.latitude))
            lon.append(Double(i.coordinate.longitude))
        }
        let alertController = UIAlertController(title: "End run?",
                                                message: "Do you wish to end your run?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.stoppingRun()
            var date = Date()
            print(date.timeIntervalSinceReferenceDate)
            //manage.saveLoc(name: "race"+String (describing: date), pace: pace, latitude: lat, longitude: lon, //fksjlaskdjfdslkfjdsklfjdslfdsjkflksdjfldksajfsdlkfjdsalfkjdsf)
            //manage.saveLoc(name: <#T##String#>, pace: <#T##[Double]#>, latitude: <#T##[Double]#>, longitude: <#T##[Double]#>)
//            paces.append(0)
//            times.append(2)

            paces.append(paces.last!)
            times.append(times.last!)
            
            manage.saveLoc(name: "race"+String (describing: date), pace: paces, latitude: lat, longitude: lon, time: times)
            print(manage.loadRunList())
            //print(manage.loadDB(runName: "race1")[0].tempList)
            
            //self.performSegue(withIdentifier: .details, sender: nil)
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.stoppingRun()
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        
        present(alertController, animated: true)
        

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(Realm.Configuration.defaultConfiguration.fileURL ?? "i")
        
        stop.isHidden = true
        start.isHidden = false
        mapView.delegate = self

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        print("dfdfsdfasgfdgsd"+String(describing: locationManager.location?.coordinate.longitude))
        mapView.showsCompass = true
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true
        mapView.showsScale = true
        mapView.showsBuildings = true
        mapView.showsTraffic = true
       // var t = MKOverlayView
        var coords: [CLLocationCoordinate2D] = []
        
       // mapView.add(MKPolyline(coordinates: &coords, count: coords.count))
        
//        let geodesic = MKGeodesicPolyline(coordinates: coords, count: 2)
//        mapView.add(geodesic)
        
        
        
        
        
        
        
        
        
        
        
        var an = MKPointAnnotation()
       // an.coordinate = (locationManager.location?.coordinate)!
        an.title = "hi"
        mapView.addAnnotation(an)
        var x = MKMapCamera()
//        x.centerCoordinate = (locationManager.location?.coordinate)!
//        x.altitude = CLLocationDistance(exactly: 1000)!
//        locationManager.headingFilter = 1
//        locationManager.startUpdatingHeading()
//        
//        print("dfdsffg"+String(describing: locationManager.heading?.magneticHeading))
//        
//        mapView.setCamera(x, animated: false)
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            let dist: CLLocationDistance
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                let deltat = newLocation.timestamp
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                dist = delta
                let x = MKMapCamera()
                x.centerCoordinate = (locationManager.location?.coordinate)!
                if delta > 0{
                x.altitude = CLLocationDistance(exactly: 0.1 * abs(Double(Double(delta)/Double(howRecent))))!
                print(0.01 * abs(Double(Double(delta)/Double(howRecent))))
                    
                    
                x.heading = newLocation.course
                mapView.setCamera(x, animated: false)
                }
            }
            
            
            
            locationList.append(newLocation)
            
            
            
            guard let mostRecentLocation = locations.last else {
                return
            }
            
            // Add another annotation to the map.
            let annotation = MKPointAnnotation()
            annotation.coordinate = mostRecentLocation.coordinate
            
            // Also add to our map so we can remove old values later
            self.locations1.append(annotation)
            
            // Remove values if the array is too big
            while locations.count > 100 {
                let annotationToRemove = self.locations1.first!
                self.locations1.remove(at: 0)
                
                // Also remove from the map
                mapView.removeAnnotation(annotationToRemove)
            }
            
            if UIApplication.shared.applicationState == .active {
                mapView.showAnnotations(self.locations1, animated: true)
            } else {
                print("App is backgrounded. New location is %@", mostRecentLocation)
            }

            
            
            
            
            
        }
    }

    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 1
        locationManager.startUpdatingLocation()
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        //print (heading.magneticHeading)
        //imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double(-heading.magneticHeading) * M_PI/180));
        var x = MKMapCamera()
        x.centerCoordinate = (locationManager.location?.coordinate)!
        x.altitude = CLLocationDistance(exactly: 1000)!
        x.heading = heading.magneticHeading
      //  mapView.setCamera(x, animated: true)
    }
    
    @IBAction func long(_ sender: Any) {
        ///
        var coords: [CLLocationCoordinate2D] = []
        var manage = DataManager()
        var cods2: [CLLocationCoordinate2D] = []
        var dataForRun = manage.loadDB(runName: "race2")
        for value in dataForRun[0].tempList{
            print(value)
            coords.append(CLLocationCoordinate2DMake (CLLocationDegrees(value.latitude), CLLocationDegrees(value.longitude)))
        }
        for i in locationList{
            cods2.append(i.coordinate)
            print(i.coordinate.latitude)
        }
//        coords.append((locationManager.location?.coordinate)!)
//        coords.append(CLLocationCoordinate2DMake(-73.760701, 41.019348))
//        coords.append(CLLocationCoordinate2DMake(40, 20))
        
        
        //mapView.add(MKPolyline(coordinates: &cods2, count: cods2.count))
        
        mapView.addOverlays(polyLine())
        
        
        
    }
    
    func timerdo(timer: Timer) {
        print("dfdfsdfasgfdgsd"+String(describing: locationManager.location?.coordinate.longitude))
        seconds+=1
        coords1.append((locationManager.location?.coordinate)!)
        
    }
    
    func eachSecond() {
        print("dfdfsdfasgfdgsd"+String(describing: locationManager.location?.coordinate.longitude))
        seconds+=1
        coords1.append((locationManager.location?.coordinate)!)
        updateDisplay()
        
    }
    

    
    
    private func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerKilometer)
        
        distanceLabel.text = "Distance:  \(formattedDistance)"
        timeLabel.text = "Time:  \(formattedTime)"
        paceLabel.text = "Pace:  \(formattedPace)"
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
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
            var times: [TimeInterval] = []
            let distance = end.distance(from: start)
            let time = second.timestamp.timeIntervalSince(first.timestamp as Date)
            times.append(time)
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
    
     fileprivate var locations1 = [MKPointAnnotation]()
    

    
    
    
    


}


