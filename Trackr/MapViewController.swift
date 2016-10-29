//
//  ViewController.swift
//  Trackr
//
//  Created by Tianyu Ying on 7/19/16.
//  Copyright © 2016 Tianyu Ying. All rights reserved.
//

import UIKit
import MapKit

struct Record {
    var userName: String?
    var title: String?
    var memo: String?
    var latitude: Double?
    var longitude: Double?
}

class MapViewController: UIViewController, CLLocationManagerDelegate, UITextViewDelegate, MapDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
//    let regionRadius: CLLocationDistance = 1000
    
    let locationManager = CLLocationManager()
    var currLocation: CLLocation?
    var currAnnotation: TrackAnnotation?
    
    var userDelegate: UserDelegate?
    
    var userName: String?
    
    @IBOutlet weak var textTitle: UITextField!
    @IBOutlet weak var textMemo: UITextView!
    
    let titlePlaceholder = "Description..."
    let memoPlaceholder = "Memo..."
    
    var first = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()

        
        mapView.delegate = self
        
        textMemo.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        textMemo.layer.borderWidth = 1.0
        textMemo.layer.cornerRadius = 5
        
        resetTextBoxes()
        
        textTitle.placeholder = titlePlaceholder
        
        textMemo.delegate = self
        setTextViewPlaceholder()
        
        currAnnotation = nil
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        checkLocationAuthorizationStatus()
    }

    func centerMapOnLocation(location: CLLocation?) {
        if location != nil {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location!.coordinate, 0.2, 0.2)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            print("true")
            mapView.showsUserLocation = true
        }
        else {
            print("false")
            locationManager.requestWhenInUseAuthorization()
        }
        
//        locationManager.requestAlwaysAuthorization()
    }
    
//    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
//        
//        currLocation = newLocation
//        centerMapOnLocation(currLocation)
//    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currLocation = locations[locations.count - 1]
        
        if first {
            centerMapOnLocation(currLocation)
            first = false
        }
    }
    
    @IBAction func signOffBtnPressed(sender: UIBarButtonItem) {
        print("Press Signoff")
        userDelegate?.userSignOff(self)
    }
    
    @IBAction func trackBtnPressed(sender: UIButton) {
        
        if textTitle.text == "" {
            PublicFuncs.showAlert(self, title: "Track", detail: "Please type in description...")
            return
        }
        
        let record = Record(userName: userName, title: textTitle.text, memo: textMemo.text, latitude: currLocation!.coordinate.latitude, longitude: currLocation!.coordinate.longitude)

        WebOperation.createNewRecord(record) {
            data, response, error in
            do {
                if data != nil {
                    if let res = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                        if let rst = res["rst"] as? NSDictionary {
                            if let status = rst["status"] as? String {
                                if status == "Success" {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.resetTextBoxes()
                                        PublicFuncs.showAlert(self, title: "Track", detail: "Success!")
                                    })
                                }
                            }
                        }
                    }
                }
            }
            catch {
                print("Something went wrong")
            }
        }
    }
    
    @IBAction func resetBtnPressed(sender: UIButton) {
        resetTextBoxes()
    }
    
    func resetTextBoxes() {
        textTitle.text = ""
        textMemo.text = ""
        setTextViewPlaceholder()
    }
    
    func setTextViewPlaceholder() {
        textMemo.text = memoPlaceholder
        textMemo.textColor = UIColor.lightGrayColor()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textMemo.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textMemo.text.isEmpty {
            setTextViewPlaceholder()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TracksSegue" {
            let controller = segue.destinationViewController as! TracksViewController
            controller.userName = userName
            controller.mapDelegate = self
        }
    }
    
    func pinOnMap(controller: UIViewController, track: Track) {
        controller.navigationController?.popViewControllerAnimated(true)
        
        if currAnnotation != nil {
            mapView.removeAnnotation(currAnnotation!)
            currAnnotation = nil
        }
        
        currAnnotation = TrackAnnotation(title: track.title!, memo: track.memo!, coordinate: CLLocationCoordinate2D(latitude: track.latitude!, longitude: track.longitude!))
        mapView.addAnnotation(currAnnotation!)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(currAnnotation!.coordinate, 0.2, 0.2)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        textTitle.resignFirstResponder()
        textMemo.resignFirstResponder()
    }
    
    @IBAction func removePinBtnPressed(sender: AnyObject) {
        if currAnnotation != nil {
            mapView.removeAnnotation(currAnnotation!)
            currAnnotation = nil
        }
    }
    
    @IBAction func centerMapBtnPressed(sender: AnyObject) {
        centerMapOnLocation(currLocation)
    }
}

