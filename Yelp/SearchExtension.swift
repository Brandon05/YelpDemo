//
//  SearchExtension.swift
//  Yelp
//
//  Created by Brandon Sanchez on 2/15/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit

extension BusinessesViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func initiateSearchController() {
        
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense. Should probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        //searchView.addSubview(searchController.searchBar)
        self.navigationController?.navigationBar.topItem?.titleView = searchController.searchBar
        //self.searchView.alpha = 0
        
        // Sets this view controller as presenting view controller for the search interface
        //definesPresentationContext = false
        
        searchController.searchBar.tintColor = UIColor.red
        var textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        searchController.searchBar.setSearchColor(withText: "Search Businesses")
        searchController.searchBar.setSerchTextcolor(color: UIColor.black)
        
        textFieldInsideSearchBar?.textColor = UIColor.black
        textFieldInsideSearchBar?.backgroundColor = UIColor.red
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //Code
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard searchBar.text != nil else {return}
        self.businesses.removeAll()
        mapView.removeAnnotations(mapView.annotations)
        print(businesses)
        self.currentTerm = searchBar.text!
        networkRequest(withTerm: currentTerm, andOffset: 0)
        self.tableView.reloadData()
        
        // Change search placeholder to current search
        searchController.searchBar.setSearchColor(withText: searchBar.text!)
        self.searchController.dismiss(animated: true, completion: nil)
        //searchController.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //code
    }
    
}

extension UISearchBar {
    public func setSerchTextcolor(color: UIColor) {
        let clrChange = subviews.flatMap { $0.subviews }
        guard let sc = (clrChange.filter { $0 is UITextField }).first as? UITextField else { return }
        sc.textColor = color
        //UISearchBar.appearance().setImage(#imageLiteral(resourceName: "searchIcon"), for: UISearchBarIcon.search, state: UIControlState.normal)
    }
    
    func setSearchColor(withText text: String) {
        let placeholderAttributes: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
        var attributedPlaceholder: NSAttributedString = NSAttributedString(string: "Search Businesses", attributes: placeholderAttributes)
        if text != nil {
            attributedPlaceholder = NSAttributedString(string: text, attributes: placeholderAttributes)
        }
        
        let textFieldPlaceHolder = self.value(forKey: "searchField") as? UITextField
        textFieldPlaceHolder?.attributedPlaceholder = attributedPlaceholder
    }
}
