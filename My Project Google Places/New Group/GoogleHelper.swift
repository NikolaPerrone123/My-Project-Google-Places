//
//  GoogleHelper.swift
//  My Project Google Places
//
//  Created by Nikola Popovic on 4/2/18.
//  Copyright © 2018 Nikola Popovic. All rights reserved.
//

import Foundation
import GooglePlaces
import GooglePlacePicker
import MapKit

class GoogleHelper {
    
    var placesClient : GMSPlacesClient!
    var appDelegate : AppDelegate!
    
    static let sharedInstance: GoogleHelper = {
        let instance = GoogleHelper()
        instance.placesClient = GMSPlacesClient.shared()
        return instance
    }()
    
    // MARK: Get Hood Places and images
    func getHoodPlaces(CompletionHandler:@escaping(_ error : Error?, _ merchants : [Merchant]?) -> Void){
        var listOfMerchants = [Merchant]()
        placesClient.currentPlace { (placeLikehoodList, error) in
            if error == nil {
                if let placeLikeHoodList = placeLikehoodList {
                    for likelihood in placeLikeHoodList.likelihoods {
                        let place = likelihood.place
                        let merchant = Merchant()
                        merchant.id = place.placeID
                        merchant.name = place.name
                        merchant.address = place.formattedAddress
                        self.getPhoto(placeId: place.placeID, CompletionHandler: { (error, photo) in
                            if error == nil {
                                merchant.image = photo
                            } else {
                                print("Problem with image: \(String(describing: error))")
                            }
                        })
                        listOfMerchants.append(merchant)
                        CompletionHandler(nil, listOfMerchants)
                        print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                        print("Current Place address \(String(describing: place.formattedAddress))")
                        print("Current Place attributions \(String(describing: place.attributions))")
                        print("Current PlaceID \(place.placeID)")
                    }
                } else {
                    print("List of hood is nil")
                    CompletionHandler(error, nil)
                }
            } else {
                print("Some error has occured: \(String(describing: error))")
                CompletionHandler(error, nil)
            }
        }
    }
    
    private func getPhoto(placeId : String, CompletionHandler:@escaping(_ error : Error?, _ image : UIImage?) -> Void){
        placesClient.lookUpPhotos(forPlaceID: placeId) { (photos, error) in
            if error == nil {
                print("Number of images: \(String(describing: photos?.results.count)) ")
                if let image = photos?.results.first {
                    self.laodImageFormMetaData(photoMetaData: image, CompletioHandler: { (error, photo) in
                        if error == nil {
                            CompletionHandler(nil, photo)
                        } else {
                            print("Error photo: \(String(describing: error))")
                            CompletionHandler(error, nil)
                        }
                    })
                }
            } else {
                print(error as Any)
            }
        }
    }
    
    private func laodImageFormMetaData(photoMetaData : GMSPlacePhotoMetadata, CompletioHandler:@escaping(_ error : Error?, _ image : UIImage?) -> Void) {
        placesClient.loadPlacePhoto(photoMetaData) { (photo, error) in
            if error == nil {
                if let photo = photo {
                    CompletioHandler(nil, photo)
                } else {
                    print("Number of error is nill")
                    CompletioHandler(error, nil)
                }
            } else {
                print(error as Any)
                CompletioHandler(error, nil)
            }
        }
    }
    
    func searchPlacesSDK(text : String, CompetionHandler:@escaping(_ error : Error?, _ merchants : [Merchant]) -> Void) {
        
        let filter = GMSAutocompleteFilter()
        filter.country = "SRB"
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        placesClient.autocompleteQuery(text, bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if error == nil {
                if let results = results {
                    for result in results {
                    
                        
                        
                        print("Result \(result.attributedFullText) with placeID \(String(describing: result.placeID))")
                    }
                }
            } else {
                print("Autocomplete error \(String(describing: error))")
            }
        })
    }
}
