//
//  HotelListModel.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/01.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

protocol HotelListModelDelegate: class {
    func hotelLocation(location: CLLocation, with error: Error?)
    func distanceFromNowLocation(distance:String)
    func didFetchHotelList(with error: Error?)
    func willBeginFetching()
}

enum Category: String {
case reasonable
case near
    var displayName: String {
      switch self {
      case .reasonable: return "安い順"
      case .near: return "近い順"
      }
    }
}
class HotelListModel {
    let categoryType: Category
    var items = [HotelItem]()
    weak var delegate: HotelListModelDelegate?
    
    
    init(for type: Category) {
        categoryType = type
    }

    func fetchLocation(placeName: String) {
        CLGeocoder().geocodeAddressString(placeName, completionHandler: { (placemarks, error) in
            if let firstPlacemark = placemarks?.first, let location = firstPlacemark.location {
                self.delegate?.hotelLocation(location: location, with: error)
            } else {
                print("nothing")
            }
        })
    }
    
    func fetchDistance(nowLocation:CLLocation, destination: CLLocation) {
        let distance = destination.distance(from: nowLocation)
        delegate?.distanceFromNowLocation(distance: "\(distance)")
        print("eeeeeeeee\(distance)")
    }
    
    func fetchHotelListData() {
        let query = Firestore.firestore().collection("HotelList")
            .order(by:"stayMin", descending: false)
        query.getDocuments { [weak self] (snapshot, error) in
             guard let `self` = self else { return }
             if let snapshot = snapshot {
                self.items = snapshot.documents.map { HotelItem(from: $0.data(), docId: $0.documentID)}
                print(self.items)
             } else {
                print("nothingDocuments")
            }
            self.delegate?.didFetchHotelList(with: error)
        }
    }
}
