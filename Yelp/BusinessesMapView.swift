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
import CoreLocation
import AFNetworking

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: URL!
    var business: Business!
}

extension BusinessesViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLocation = locations[0]
//        print("USER: \(userLocation.coordinate.longitude), \(userLocation.coordinate.latitude)")
        let center = LocationService.sharedInstance.currentLocation?.coordinate //location
        let region = MKCoordinateRegionMake(center!, MKCoordinateSpan(latitudeDelta: 0.050, longitudeDelta: 0.050))
        //mapView.setRegion(region, animated: true)
        
        var allAnnMapRect = MKMapRectNull
        let annotations = businesses.flatMap { business -> MKPointAnnotation in
            let annotation = CustomPointAnnotation()
            annotation.coordinate = business.coordinate!
            annotation.title = business.name
            annotation.imageName = business.imageURL
            annotation.business = business
            
            let thisAnnMapPoint = MKMapPointForCoordinate(annotation.coordinate)
            let thisAnnMapRect = MKMapRectMake(thisAnnMapPoint.x, thisAnnMapPoint.y, 1, 1)
            allAnnMapRect = MKMapRectUnion(allAnnMapRect, thisAnnMapRect)
            
            return annotation
        }
        
        
        
        //Set inset (blank space around all annotations) as needed...
        //These numbers are in screen CGPoints...
        let edgeInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        self.mapView.setVisibleMapRect(allAnnMapRect, edgePadding: edgeInset, animated: true)
        
        mapView.addAnnotations(annotations)
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! CustomPointAnnotation
        performSegue(withIdentifier: "DetailSegue", sender: annotation.business)
    }
    
    func presentMap() {
        UIView.transition(with: self.view, duration: 0.3, options: UIViewAnimationOptions.transitionFlipFromBottom, animations: {
            self.view.bringSubview(toFront: self.mapView)
        }) { (finished: Bool) in
        }
    }
    
    func removeMap() {
        UIView.transition(with: self.view, duration: 0.3, options: UIViewAnimationOptions.transitionFlipFromTop, animations: {
            self.view.bringSubview(toFront: self.tableView)
        }) { (finished: Bool) in
        }
    }
}
