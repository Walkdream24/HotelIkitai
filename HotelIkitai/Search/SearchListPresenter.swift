//
//  SearchListPresenter.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/17.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import Foundation
import CoreLocation

class SearchListPresenter {
    
    private let model: SearchListModel
    private weak var view: SearchListView?
    var categoryType: Category { return model.categoryType }
    var hotelItem: [HotelItem] { return model.items }
    
    init(view: SearchListView, type: Category ) {
        self.view = view
        self.model = SearchListModel(for: type)
        model.delegate = self
    }
    
    func sendRequestArea(requestArea :String) {
        model.areaRequest(areaText: requestArea)
    }
    
    func searchStart(searchWord: String, nowLocation: CLLocation) {
        view?.presentActivityIndicator(message: "検索中...")
        model.fetchsearchArea(searchWord: searchWord, nowLocation: nowLocation)
    }
    
    func toDetail(hotel: HotelItem, restMin: Int, stayMin: Int, latitude: Double, longitude: Double, distance: Double) {
        view?.toDetail(hotel: hotel, restMin: restMin, stayMin: stayMin, latitude: latitude, longitude: longitude, distance: distance)
    }
}

extension SearchListPresenter: SearchListModelDelegate {
    func sentRequest() {
        view?.showCompleteMessage()
    }
    
    func didFetchSearchResults(with error: Error?) {
        if error != nil {
            view?.dismissActivityIndicator()
            print("error\(String(describing: error?.localizedDescription))")
        } else {
            if hotelItem.isEmpty {
                view?.dismissActivityIndicator()
                view?.reLoad()
                view?.resultNothing()
            } else {
                view?.dismissActivityIndicator()
                view?.reLoad()
                print("reLoad!!!!!!!")
            }
        }
    }
}

