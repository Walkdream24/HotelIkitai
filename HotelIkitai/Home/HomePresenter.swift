//
//  HomePresenter.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/01.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import Foundation
import CoreLocation

class HomePresenter {
    private var view: HomeView!
    private var model: HomeModel!
    
    init(view: HomeView) {
        self.view = view
        self.model = HomeModel()
        self.model.delegate = self
    }
    
    func fetchLocation(location: CLLocation) {
        model.getPlaceName(location: location)
    }
    func toSearch() {
        view.toSearch()
    }
}

extension HomePresenter: HomeModelDelegate {
    func fetchedLocation(placeName: String, with error: Error?) {
        if let error = error {
            print(error)
        } else {
            view.updateLocation(placeName: placeName)
            view.locationBool()
            print("aaaaaaa\(placeName)")
        }
    }

}
