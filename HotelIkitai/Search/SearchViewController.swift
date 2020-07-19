//
//  SearchViewController.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/02.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import CoreLocation

protocol SearchViewInterface: class {
    func searchStart(searchWord: String, nowLocation: CLLocation)
}

class SearchViewController: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var searchFrameView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    var nowLocation: CLLocation?
    var delegates = RMWeakSet<SearchViewInterface>()

    
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .clear
        settings.style.buttonBarLeftContentInset = 20
        settings.style.buttonBarMinimumLineSpacing = 11
        settings.style.buttonBarRightContentInset = 150
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 16)
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex else { return }
            oldCell?.backgroundColor = UIColor(hex: "F5F5F5")
            oldCell?.layer.cornerRadius = (oldCell?.frame.height)! / 2
            newCell?.backgroundColor = UIColor.black
            newCell?.layer.cornerRadius = (newCell?.frame.height)! / 2
            oldCell?.label.textColor = .black
            oldCell?.label.font = .boldSystemFont(ofSize: 15)
            newCell?.label.textColor = .white
            newCell?.label.font = .boldSystemFont(ofSize: 15)
        }
            
        super.viewDidLoad()
        searchFrameView.layer.cornerRadius = 5
        searchTextField.becomeFirstResponder()
        searchTextField.delegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(true)
          navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let reasonableList = SearchListViewController.instantiate(forType: .reasonable)
        let nearList = SearchListViewController.instantiate(forType: .near)
        delegates = RMWeakSet([reasonableList,nearList])
           return [nearList, reasonableList]
    }
    


}
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        
        if !(searchTextField.text!.isEmpty) {
            self.delegates.forEach{$0.searchStart(searchWord: searchTextField.text!, nowLocation: nowLocation!)}
        }
        return true
    }
    
}
