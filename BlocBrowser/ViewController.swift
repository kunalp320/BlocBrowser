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
    private var backButton : UIButton?
    private var forwardButton : UIButton?
    private var stopButton : UIButton?
    private var reloadButton : UIButton?
    private var activityIndicator : UIActivityIndicatorView?
    
    // MARK: ViewController
    
    override func loadView() {
        let mainView = UIView()
        self.edgesForExtendedLayout = UIRectEdge.None
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.activityIndicator!)
        
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
        
        self.backButton = UIButton(type: UIButtonType.System)
        self.backButton?.enabled = false
        self.backButton?.setTitle(NSLocalizedString("Back", comment: "Back command"), forState: UIControlState.Normal)
        self.backButton?.addTarget(self.webView, action: "goBack:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.forwardButton = UIButton(type: UIButtonType.System)
        self.forwardButton?.enabled = false
        self.forwardButton?.setTitle(NSLocalizedString("Forward", comment: "Forward Command"), forState: UIControlState.Normal)
        self.forwardButton?.addTarget(self.webView, action: "goFoward:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.stopButton = UIButton(type: UIButtonType.System)
        self.stopButton?.setTitle(NSLocalizedString("Stop", comment: "Stop Command"), forState: UIControlState.Normal)
        self.stopButton?.enabled = false
        self.stopButton?.addTarget(self.webView, action: "stopLoading:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.reloadButton = UIButton(type: UIButtonType.System)
        self.reloadButton?.setTitle(NSLocalizedString("Reload", comment: "Reload Command"), forState: UIControlState.Normal)
        self.reloadButton?.enabled = false
        self.reloadButton?.addTarget(self.webView, action: "reload:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let urlString = "https://www.wikipedia.org"
        let url = NSURL(string: urlString)
        
        let request = NSURLRequest(URL: url!)
        self.webView.loadRequest(request)
        
        
        mainView.addSubview(self.urlTextField!)
        mainView.addSubview(self.webView)
        mainView.addSubview(self.backButton!)
        mainView.addSubview(self.forwardButton!)
        mainView.addSubview(self.stopButton!)
        mainView.addSubview(self.reloadButton!)
        self.view = mainView
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let itemHeight : CGFloat = 50
        let width = CGRectGetWidth(self.view.bounds)
        let browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight - itemHeight
        
        let buttonWidth = CGRectGetWidth(self.view.bounds) / 4
        var currentButton : CGFloat = 0
        
        for thisButton in [self.backButton!, self.forwardButton!, self.stopButton!, self.reloadButton!] {
            thisButton.frame = CGRectMake(currentButton, CGRectGetMaxY(self.webView.frame), buttonWidth, itemHeight)
            currentButton = currentButton + buttonWidth
        }
        
        

        self.urlTextField!.frame = CGRectMake(0, 0, width, itemHeight)
        self.webView.frame = CGRectMake(0, CGRectGetMaxY((self.urlTextField?.frame)!), width, browserHeight)
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        self.webView(webView, didFailNavigation: navigation, withError: error)
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        
        if error.code != NSURLErrorCancelled {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: NSLocalizedString("Error", comment: "Error"), style: UIAlertActionStyle.Cancel, handler: nil)
            
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        self.updateButtonsAndTitle()
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.updateButtonsAndTitle()
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.updateButtonsAndTitle()
    }
    
    func updateButtonsAndTitle() {
        let title : String = self.webView.title ?? ""
        
        if title != "" {
            self.title = title
        } else {
            self.title = self.webView.URL?.absoluteString
        }
        
        if self.webView.loading {
            self.activityIndicator?.startAnimating()
        } else {
            self.activityIndicator?.stopAnimating()
        }
        
        self.backButton?.enabled = self.webView.canGoBack
        self.forwardButton?.enabled = self.webView.canGoForward
        self.stopButton?.enabled = self.webView.loading
        self.reloadButton?.enabled = !self.webView.loading
    }

    // MARK: UITextFieldDelegate
    
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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

