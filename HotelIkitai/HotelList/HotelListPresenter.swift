//
//  HotelListPresenter.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/01.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import Foundation
import CoreLocation

class HotelListPresenter {
    
    private let model: HotelListModel
    private weak var view: HotelListView?
    var categoryType: Category { return model.categoryType }
    var hotelItem: [HotelItem] { return model.items }
    var firstTime = true
    
    init(view: HotelListView, type: Category ) {
        self.view = view
        self.model = HotelListModel(for: type)
        model.delegate = self
    }
    
    func toDetail(hotel: HotelItem, restMin: Int, stayMin: Int, latitude: Double, longitude: Double, distance: Double) {
        view?.toDetail(hotel: hotel, restMin: restMin, stayMin: stayMin, latitude: latitude, longitude: longitude, distance: distance)
        
    }
    func viewDidLoad() {
        model.fetchLocation(placeName: "東京都武蔵野市御殿山１丁目３−３")
    }
    func viewWillAppear(nowLocation: CLLocation) {
        if firstTime {
            model.fetchHotelListData(nowLocation: nowLocation)
            firstTime = false
        }
    }

    func goActivityIndicator() {
        view!.presentActivityIndicator(message: "読み込み中...")
    }
}
extension HotelListPresenter: HotelListModelDelegate {
    func didFetchHotelList(with error: Error?) {
//        view!.presentActivityIndicator(message: "読み込み中...")
        if error != nil {
            view?.dismissActivityIndicator()
            print("eeeeeeerrorrrrrrrrrrrrrrrrr\(String(describing: error?.localizedDescription))")
        } else {
            view?.dismissActivityIndicator()
            view?.reLoad()
            print("reLoad!!!!!!!")
        }
    }
    
     func willBeginFetching() {
        view!.presentActivityIndicator(message: "読み込み中...")
        print("aaaaaaaaaaできてる")
     }
    
    func hotelLocation(location: CLLocation, with error: Error?) {
        if error != nil {
            print("error")
        } else {
//            model.fetchDistance(nowLocation: , destination: location)
        }
    }
    
    func distanceFromNowLocation(distance: String) {
         view?.dismissActivityIndicator()
        
    }
    
    
}
