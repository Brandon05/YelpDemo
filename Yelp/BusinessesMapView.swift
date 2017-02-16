//
//  BusinessesMapView.swift
//  Yelp
//
//  Created by Brandon Sanchez on 2/16/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension BusinessesViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: 37.785771, longitude: -122.406165)
        let center = location
        let region = MKCoordinateRegionMake(center, MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
        mapView.setRegion(region, animated: true)
        
        let coordinates = businesses.flatMap {return $0.coordinate}
        
        for coordinate in coordinates {
            let annotaion = MKPointAnnotation()
            annotaion.coordinate = coordinate
            mapView.addAnnotation(annotaion)
        }
        
        //mapView.reloadInputViews()
    }
    
    //MARK: - Custom Annotation
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        //let customPointAnnotation = annotation as! CustomPointAnnotation
        //annotationView?.image = UIImage(named: customPointAnnotation.pinCustomImageName)
        
        return annotationView
    }
}
