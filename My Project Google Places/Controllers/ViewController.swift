//
//  ViewController.swift
//  My Project Google Places
//
//  Created by Nikola Popovic on 3/30/18.
//  Copyright © 2018 Nikola Popovic. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var resultViewContorller : GMSAutocompleteResultsViewController!
    var searchController : UISearchController!
    var placePicker : GMSPlacePickerViewControllerDelegate!
    var autocompliteController: GMSAutocompleteViewController!
    var appDelegate : AppDelegate!
    var placesClient : GMSPlacesClient!
    var locationManager = CLLocationManager()
    var listOfImage = [UIImage]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        placesClient = GMSPlacesClient.shared()
    }
    
    @IBAction func pickPlace(_ sender: UIButton) {
        
        self.presentMapWithPiceker()
    }
    
    
    func presentMapWithPiceker(){
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
    }
    
    func presentFullScreenContorll(){
        autocompliteController = GMSAutocompleteViewController()
        autocompliteController.delegate = self
        present(autocompliteController, animated: true, completion: nil)
    }
    
    // MARK: currentLocation
    func currentLocation(){
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.nameLabel.text = "No current place"
            self.addressLabel.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    //print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                    print("Current Place address \(String(describing: place.formattedAddress))")
                    print("Current Place attributions \(String(describing: place.attributions))")
                    print("Current PlaceID \(place.placeID)")
                    self.getPhoto(placeId: place.placeID)
                    self.nameLabel.text = place.name
                    self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                }
            }
        })
    }
    
    // MARK: Get Hood Places and images
    func getHoodPlaces(){
        placesClient.currentPlace { (placeLikehoodList, error) in
            if error == nil {
                if let placeLikeHoodList = placeLikehoodList {
                    for likelihood in placeLikeHoodList.likelihoods {
                        
                        //likelihood.place.

                        let place = likelihood.place
                        self.getPhoto(placeId: place.placeID)
                        print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                        print("Current Place address \(String(describing: place.formattedAddress))")
                        print("Current Place attributions \(String(describing: place.attributions))")
                        print("Current PlaceID \(place.placeID)")
                    }
                }
            } else {
                print("Some error has occured: \(String(describing: error))")
            }
        }
    }
    
    func getPhoto(placeId : String){
        placesClient.lookUpPhotos(forPlaceID: placeId) { (photos, error) in
            if error == nil {
                print("Number of images: \(String(describing: photos?.results.count)) ")
                if let image = photos?.results.first {
                    self.laodImageFormMetaData(photoMetaData: image)
                }
            } else {
                print(error as Any)
            }
        }
    }
    
    func laodImageFormMetaData(photoMetaData : GMSPlacePhotoMetadata) {
        placesClient.loadPlacePhoto(photoMetaData) { (photo, error) in
            if error == nil {
                //self.placeImage.image = photo
                // Set image
                if let photo = photo {
                    self.listOfImage.append(photo)
                    print("Number of photo: \(String(describing: self.listOfImage.count))")
                } else {
                    print("Number of image is nill")
                }
            } else {
                print(error as Any)
            }
        }
    }
    
    func presentResultViewContorller(){
        resultViewContorller = GMSAutocompleteResultsViewController()
        resultViewContorller.delegate = self
        
        // You can costumize table view of results.
        resultViewContorller.tableCellBackgroundColor = UIColor.gray
        
        searchController = UISearchController(searchResultsController: resultViewContorller)
        searchController?.searchResultsUpdater = resultViewContorller
        
        self.present(withView: true)
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
    
    func present(withView : Bool) {
        if withView {
            let subView = UIView(frame: CGRect(x: 0, y: 165.0, width: 350.0, height: 45.0))
            
            subView.addSubview((searchController?.searchBar)!)
            view.addSubview(subView)
            searchController?.searchBar.sizeToFit()
            searchController?.hidesNavigationBarDuringPresentation = false
        } else {
            // Put the search bar in the navigation bar.
            searchController?.searchBar.sizeToFit()
            navigationItem.titleView = searchController?.searchBar
            
            // Prevent the navigation bar from being hidden when searching.
            searchController?.hidesNavigationBarDuringPresentation = false
        }
    }
    
    
    // MARK: Search By Auto Complite
    func placeAutocomplete(){
        let filter = GMSAutocompleteFilter()
        
        filter.country = "SRB"
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        placesClient.autocompleteQuery(textField.text!, bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                for result in results {
                    
                    print("Result \(result.attributedFullText) with placeID \(String(describing: result.placeID))")
                }
            }
        })
    }
}



// MARK: Extension GMSAutocompleteViewControllerDelegate
extension ViewController : GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

// MARK: Extension GMSPlacePickerViewControllerDelegate
extension ViewController : GMSPlacePickerViewControllerDelegate {
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        print(place.name)
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: Extension GMSAutocompleteResultsViewControllerDelegate
extension ViewController : GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
//    // Turn the network activity indicator on and off again.
//    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//
//    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
}

extension ViewController : MKMapViewDelegate {
    
}
