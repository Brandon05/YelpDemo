//
//  DetailViewController.swift
//  Yelp
//
//  Created by Brandon Sanchez on 2/19/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var business: Business!
    var businessID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(business)
        print(businessID)
        
        Business.getBusiness(withID: businessID) { (business: Business?, error: Error?) in
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
