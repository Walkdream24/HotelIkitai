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
    private let db = Firestore.firestore()
    weak var delegate: HotelListModelDelegate?
    
    
    init(for type: Category) {
        categoryType = type
    }

    
    func fetchDistance(nowLocation:CLLocation, destination: CLLocation) {
        let distance = destination.distance(from: nowLocation)
        delegate?.distanceFromNowLocation(distance: "\(distance)")
    }
    
    
    func fetchHotelListData(nowLocation: CLLocation) {
        var query: Query! = nil
        let colRef = db.collection("HotelList")
//        switch categoryType {
//        case .reasonable:
//            query = colRef.order(by:"stayMin", descending: false)
//        case .near:
//            query = colRef.order(by:"stayMin", descending: false)
//        }
        query = colRef.order(by:"stayMin", descending: false)
        .whereField("stayMin", isLessThan: 900000)
        query.getDocuments { [weak self] (snapshot, error) in
             guard let `self` = self else { return }
             if let snapshot = snapshot {
                self.items = snapshot.documents.map { HotelItem(from: $0.data(), docId: $0.documentID, nowLocation: nowLocation)}
                switch self.categoryType {
                case .reasonable:
                    print("配列操作ない")
                case .near:
                    self.items = self.items.sorted(by: { (a, b) -> Bool in
                        return a.distance < b.distance
                    })
                }
             } else {
                print("nothingDocuments")
            }
            self.delegate?.didFetchHotelList(with: error)
        }
    }
    
    
}
