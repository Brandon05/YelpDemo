//
//  DetailMapView.swift
//  Yelp
//
//  Created by Brandon Sanchez on 2/20/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import AFNetworking

extension DetailViewController: MKMapViewDelegate, CLLocationManagerDelegate, LocationServiceDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        let userLocation = locations[0]
        //        print("USER: \(userLocation.coordinate.longitude), \(userLocation.coordinate.latitude)")
        let center = LocationService.sharedInstance.currentLocation?.coordinate //location
        //let region = MKCoordinateRegionMake(center!, MKCoordinateSpan(latitudeDelta: 0.050, longitudeDelta: 0.050))
        //mapView.setRegion(region, animated: true)
        
        var allAnnMapRect = MKMapRectNull
        let annotation = CustomPointAnnotation()
        annotation.coordinate = business.coordinate!
        annotation.title = business.name
        annotation.imageName = business.imageURL
        annotation.business = business
        
        let latitude = center?.latitude
        let longitude = center?.longitude
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        
        let thisAnnMapPoint = MKMapPointForCoordinate(annotation.coordinate)
        let thisAnnMapRect = MKMapRectMake(thisAnnMapPoint.x, thisAnnMapPoint.y, 1, 1)
        allAnnMapRect = MKMapRectUnion(allAnnMapRect, thisAnnMapRect)
        
        //Set inset (blank space around all annotations) as needed...
        //These numbers are in screen CGPoints...
        let edgeInset = UIEdgeInsetsMake(5, 5, 5, 5)
        self.mapView.setRegion(region, animated: true)
        //self.mapView.setVisibleMapRect(allAnnMapRect, edgePadding: edgeInset, animated: true)
        
        mapView.addAnnotation(annotation)
        //locationManager.stopUpdatingLocation()
        print("stopped")
    }
    
    //MARK: - Custom Annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //        let reuseIdentifier = "pin"
        //        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        //
        //        if annotationView == nil {
        //            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        //            annotationView?.canShowCallout = true
        //        } else {
        //            annotationView?.annotation = annotation
        //        }
        //
        //        //let customPointAnnotation = annotation as! CustomPointAnnotation
        //        //annotationView?.image = UIImage(named: customPointAnnotation.pinCustomImageName)
        //
        //        return annotationView
        
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        let cpa = annotation as! CustomPointAnnotation
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            let annotationViewImage = UIImageView()
            annotationViewImage.setImageWith(cpa.imageName)
            annotationView.image = #imageLiteral(resourceName: "annotationImage")
        }
        
        return annotationView
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
        
    }
    
    func tracingLocation(_ currentLocation: CLLocation) {
        print("getting current location")
    }

}
