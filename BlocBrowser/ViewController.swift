//
//  ViewController.swift
//  BlocBrowser
//
//  Created by Kunal Patel on 3/22/16.
//  Copyright © 2016 bootcamp. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate {
 
    private var webView : WKWebView!
    private var urlTextField : UITextField?
    
    override func loadView() {
        let mainView = UIView()
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.webView = WKWebView()
        self.webView.navigationDelegate = self
        
        self.urlTextField = UITextField()
        self.urlTextField?.keyboardType = UIKeyboardType.URL
        self.urlTextField?.returnKeyType = UIReturnKeyType.Done
        self.urlTextField?.autocapitalizationType = UITextAutocapitalizationType.None
        self.urlTextField?.autocorrectionType = UITextAutocorrectionType.No
        self.urlTextField?.placeholder = NSLocalizedString("Website URL", comment: "Placeholder text for web browser URL field")
        self.urlTextField?.backgroundColor = UIColor(white: 220/255.0, alpha: 1)
        self.urlTextField?.delegate = self
        
        let urlString = "https://www.wikipedia.org"
        let url = NSURL(string: urlString)
        
        let request = NSURLRequest(URL: url!)
        self.webView.loadRequest(request)
        
        
        mainView.addSubview(self.urlTextField!)
        mainView.addSubview(self.webView)
        self.view = mainView
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.urlTextField?.resignFirstResponder()
        
        let urlString = urlTextField?.text ?? ""
        var URL = NSURL(string: urlString)

        if let _ = URL {
        } else {
            URL = NSURL(string: "https://\(urlString)")
        }
        
        if URL != nil {
            let request = NSURLRequest(URL: URL!)
            self.webView.loadRequest(request)
        }
        return false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let itemHeight : CGFloat = 50
        let width = CGRectGetWidth(self.view.bounds)
        let browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight
        
        self.urlTextField!.frame = CGRectMake(0, 0, width, itemHeight)
        self.webView.frame = CGRectMake(0, CGRectGetMaxY((self.urlTextField?.frame)!), width, browserHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

