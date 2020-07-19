//
//  NothingResultsView.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/19.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import Foundation
import UIKit

class NothingResultsView: UIView {
    
    @IBOutlet weak var searchedLabel: UILabel!
    @IBOutlet weak var requestButton: UIButton!
    
    var searchText = ""
    var presenter: SearchListPresenter?
    
    static func instantiate(presenter: SearchListPresenter) -> NothingResultsView {
        let view = R.nib.nothingResultsView.firstView(owner: nil)!
        view.presenter = presenter
        view.requestButton.layer.cornerRadius = view.requestButton.bounds.height / 2
        return view
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func setSearchText() {
        searchedLabel.text = "「\(searchText)」エリアは見つかりませんでした...😢"
    }
    
    @IBAction func RequestButtonTapped(_ sender: UIButton) {
        presenter?.sendRequestArea(requestArea: searchText)
    }
    
}
