//
//  InstaLoginViewController.swift
//  cook-pad
//
//  Created by Naste, Ishwar (US - Bengaluru) on 6/14/18.
//  Copyright © 2018 Ishwar Naste. All rights reserved.
//

import UIKit
import WebKit

protocol InstaAuthrizationDelegate {
    func didReceiveAuthrizationCode(code: String)
}

class InstaLoginViewController: UIViewController,WKNavigationDelegate {
    let authorizationURL = "https://api.instagram.com/oauth/authorize/?client_id=0755f4a7f9984731b48288904a0aaffa&redirect_uri=http://cook-pad-ios.com&response_type=code&scope=public_content"
    @IBOutlet weak var instaLoginWebView: WKWebView!
    var delegate : InstaAuthrizationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let instaURL = URL(string: authorizationURL)!
        instaLoginWebView = WKWebView()
        instaLoginWebView.navigationDelegate = self
        view = instaLoginWebView
        instaLoginWebView.load(URLRequest(url: instaURL))
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Please Wait"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = ""
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.url?.absoluteString.range(of:"http://cook-pad-ios.com/?code=") != nil {
            let utl = Utility()
            let authorizationCode = utl.getQueryStringParameter(url: (navigationAction.request.url?.absoluteString)!, param: "code")
            decisionHandler(.cancel)
            delegate?.didReceiveAuthrizationCode(code: authorizationCode!)
        }
        else{
            decisionHandler(.allow)
        }
    }
}

