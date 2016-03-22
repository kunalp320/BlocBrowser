//
//  ViewController.swift
//  BlocBrowser
//
//  Created by Kunal Patel on 3/22/16.
//  Copyright © 2016 bootcamp. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
 
    private var webView : WKWebView!
    
    override func loadView() {
        let mainView = UIView()

        self.webView = WKWebView()
        self.webView.navigationDelegate = self
        
        let urlString = "http://www.wikipedia.org"
        let url = NSURL(string: urlString)
        
        let request = NSURLRequest(URL: url!)
        self.webView.loadRequest(request)
        
        
        mainView.addSubview(self.webView)
        self.view = mainView
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.webView.frame = self.view.frame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

