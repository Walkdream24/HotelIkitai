//
//  SearchViewController.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/02.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchFrameView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var emptyView: EmptyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFrameView.layer.cornerRadius = 5
        searchTextField.becomeFirstResponder()
        searchTextField.delegate = self
        emptyView = EmptyView.instantiate()
        self.collectionView.backgroundView = emptyView

    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(true)
          navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    


}
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        
        self.collectionView.backgroundView = nil
//        if !(searchTextField.text!.isEmpty) {
//
//        }
        return true
    }
    
}
