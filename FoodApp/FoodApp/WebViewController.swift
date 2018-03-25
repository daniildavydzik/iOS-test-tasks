//
//  WebViewController.swift
//  FoodApp
//
//  Created by Daniil Davydik  on 02.05.17.
//  Copyright © 2017 DavydzikInc. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController {
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: "http://www.appcoda.com/contact") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
