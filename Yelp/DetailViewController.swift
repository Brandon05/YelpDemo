//
//  DetailViewController.swift
//  Yelp
//
//  Created by Brandon Sanchez on 2/19/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    var business: Business!
    var businessID: String!
    
    @IBOutlet var businessImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var categoriesLabel: UILabel!
    @IBOutlet var ratingsImageView: UIImageView!
    @IBOutlet var reviewCountLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    let locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(business)
        print(businessID)
        
        LocationService.sharedInstance.delegate = self
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.delegate = self
        if #available(iOS 9.0, *) {
            locationManager.requestLocation()
            //print("\(locationManager.location?.coordinate)")
            LocationService.sharedInstance.getCurrentLocation()
        } else {
            // Fallback on earlier versions
        }
        
        var imageView = UIImageView()
        //var image = UIImage()
        imageView.setImageWith(business.imageURL!)
        if let image = imageView.image {
           businessImage.image = image.resizedImageWithinRect(rectSize: CGSize(width: 400, height: 400)) 
        }
        
        businessImage.clipsToBounds = true
        businessImage.layer.cornerRadius = 6
        nameLabel.text = business.name
        categoriesLabel.text = business.categories
        reviewCountLabel.text = String(describing: business.reviewCount!) + " Reviews"
        ratingsImageView.setImageWith(business.ratingImageURL!)
        
        Business.getBusiness(withID: businessID) { (business: Business?, error: Error?) in
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissDetails(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func openMaps(_ sender: Any) {
        
        let latitude: CLLocationDegrees = 37.2
        let longitude: CLLocationDegrees = 22.9
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = business.coordinate
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates!, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates!, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = business.name
        mapItem.openInMaps(launchOptions: options)
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

extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
    /// Note that the new image size is not rectSize, but within it.
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        
        let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
    
}

