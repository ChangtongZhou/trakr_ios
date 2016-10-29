//
//  VCMapView.swift
//  Trackr
//
//  Created by Tianyu Ying on 7/19/16.
//  Copyright © 2016 Tianyu Ying. All rights reserved.
//

import MapKit

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is TrackAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView?
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) {
                dequeuedView.annotation = annotation
                view = dequeuedView as? MKPinAnnotationView
            }
            else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view?.canShowCallout = true
                view?.calloutOffset = CGPoint(x: -5, y: 5)
                view?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            
            return view
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! TrackAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
}