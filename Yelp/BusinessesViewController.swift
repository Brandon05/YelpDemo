//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LocationServiceDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    //var pointAnnotation:CustomPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    let refreshControl = UIRefreshControl()
    
    var searchController: UISearchController!
    
    var businesses = [Business]()
    
    var isMoreDataLoading = false
    
    var currentTerm = "Food"
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension // property need for dynamic cells
        tableView.estimatedRowHeight = 120 // must be run with above^
        
        refreshControl.addTarget(self, action: #selector(BusinessesViewController.refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.automaticallyAdjustsScrollViewInsets = false // prevent gap between tableview and nav bar
        
        initiateSearchController()
        
        LocationService.sharedInstance.delegate = self
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.delegate = self
        //locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 9.0, *) {
            locationManager.requestLocation()
            //print("\(locationManager.location?.coordinate)")
            LocationService.sharedInstance.getCurrentLocation()
        } else {
            // Fallback on earlier versions
        }
        //print("\(LocationService.sharedInstance.)")
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        networkRequest(withTerm: currentTerm, andOffset: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        refreshControl.tintColor = UIColor.black
        //api call
        networkRequest(withTerm: currentTerm, andOffset: 0)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard businesses != nil else {return 0}
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    func networkRequest(withTerm term: String, andOffset offset: Int) {
        Business.searchWithTerm(term: term, offset: offset, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            let filteredBusinesses = businesses.flatMap {return $0}
//            for business in filteredBusinesses! {
//                self.businesses.append(business)
//            }
            self.businesses += filteredBusinesses!
            //self.businesses += businesses.flatMap {return $0}
            self.isMoreDataLoading = false
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.mapView.reloadInputViews()
            //self.locationManager.startUpdatingLocation()
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
        
    }
    
    func tracingLocation(_ currentLocation: CLLocation) {
        print("getting current location")
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
