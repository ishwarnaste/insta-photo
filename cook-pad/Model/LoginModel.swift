//
//  FetchModel.swift
//  cook-pad
//
//  Created by Naste, Ishwar (US - Bengaluru) on 6/13/18.
//  Copyright © 2018 Ishwar Naste. All rights reserved.
//

import UIKit


protocol LoginDelegate {
    func didLoginSuccessfully()
    func didFailToLogin()
}


class LoginModel: NSObject, FetchServiceDelegate {
    
    var loginDelegate : LoginDelegate?

    
    func fetchServiceHandler(data: [String : Any], response: HTTPURLResponse?) {

        let token:String = data["access_token"] as! String
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "SESSION_TOKEN")
        defaults.synchronize()
        self.loginDelegate?.didLoginSuccessfully()
        //1373199669.0755f4a.53d3596586ce47018a603ecd74710258
    }
    
    func fetchServiceServerErrorHandler(error: Error?, response: HTTPURLResponse?) {
        //TODO handle failure
        self.loginDelegate?.didLoginSuccessfully()
    }
    
    func fetchServiceClientErrorHandler(error: Error?) {
        self.loginDelegate?.didLoginSuccessfully()
    }
    
    func fetchTokenHandler() {
        
    }
    
    func getToken(authCode: String, delegate: LoginDelegate) {
        let fetchService = FetchServices()
        self.loginDelegate = delegate
        fetchService.getAccessToken(delegate: self, param:nil, baseUrl: "https://api.instagram.com/oauth/access_token", postBodyString: "client_id=0755f4a7f9984731b48288904a0aaffa&client_secret=5bca8cb6528f466ba121ab21b0ac70e7&grant_type=authorization_code&redirect_uri=http://cook-pad-ios.com&code=\(authCode)")
    }
}
