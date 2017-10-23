//
//  SecondViewController.swift
//  GitHub Viewer
//
//  Created by Sujay Patwardhan on 10/19/17.
//  Copyright © 2017 Sujay Patwardhan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewWebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    struct Person {
        let userName : String
        let url : URL
    }
    var people = [Person]()
    var json : JSON = JSON.null;
    var user : String = USER + "/followers";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
//        self.webView.loadURL()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
//        if navigationType == UIWebViewNavigationType.LinkClicked {
//            UIApplication.sharedApplication().openURL(request.URL!)
//            return false
//        }
        
        return true
    }
}

