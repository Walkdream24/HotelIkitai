//
//  StaticWebViewController.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/17.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView

class StaticWebViewController: UIViewController {
    
    var webView: WKWebView!
    var url: URL
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url: url))
    }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(false, animated: false)
            navigationController?.navigationBar.tintColor = UIColor.black
    }
    


}
extension StaticWebViewController: WKNavigationDelegate, NVActivityIndicatorViewable {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopAnimating()
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        stopAnimating()
    }
}
