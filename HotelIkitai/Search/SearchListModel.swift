//
//  SearchListModel.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/17.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

protocol SearchListModelDelegate: class {
    func didFetchSearchResults(with error: Error?)
    func sentRequest()
}

class SearchListModel {
    
    let categoryType: Category
    var items = [HotelItem]()
    private let db = Firestore.firestore()
    weak var delegate: SearchListModelDelegate?
    
    init(for type: Category) {
         categoryType = type
    }
    
    func areaRequest(areaText: String) {
        db.collection("Requests").addDocument(data: ["requestArea": areaText, "sendAt": Timestamp()]) { (err) in
            if let err = err {
                print("Failed to send request",err)
                return
            }
            self.delegate?.sentRequest()
        }
    }
    

    func fetchsearchArea(searchWord: String, nowLocation: CLLocation) {
        var query: Query! = nil
        let colRef = db.collection("HotelList")
        
        query = colRef.order(by:"stayMin", descending: false)
            .whereField("stayMin", isLessThan: 900000)
            .whereField("area", isEqualTo: searchWord)
        query.getDocuments { [weak self] (snapshot, error) in
                 guard let `self` = self else { return }
                 if let snapshot = snapshot {
                    self.items = snapshot.documents.map { HotelItem(from: $0.data(), docId: $0.documentID, nowLocation: nowLocation)}
                    switch self.categoryType {
                    case .reasonable:
                        print("配列操作ないよよ")
                    case .near:
                        self.items = self.items.sorted(by: { (a, b) -> Bool in
                            return a.distance < b.distance
                        })
                    }
                 } else {
                    print("nothingDocuments")
                }
                self.delegate?.didFetchSearchResults(with: error)
            }
        }
    
}
