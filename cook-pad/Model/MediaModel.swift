//
//  MediaModel.swift
//  cook-pad
//
//  Created by Naste, Ishwar (US - Bengaluru) on 6/15/18.
//  Copyright © 2018 Ishwar Naste. All rights reserved.
//

import UIKit

protocol MediaDelegate {
    func didReceiveMediaSuccessfully(data: [Any])
    func didFailToGetMedia()
}


class MediaModel: NSObject, FetchServiceDelegate {
    
    var mediaDelegate : MediaDelegate?

    func getMediaByTags(tag: String, delegate:MediaDelegate) {
        let fetchService = FetchServices()
        self.mediaDelegate = delegate
        let defaults = UserDefaults.standard
        let token = defaults.value(forKey: "SESSION_TOKEN") as! String
        let mediaUrl = "https://api.instagram.com/v1/tags/\(tag)/media/recent?access_token=\(token)&scope=public_content"
        fetchService.getMedia(delegate: self, baseUrl: mediaUrl)
    }
    
    func fetchServiceHandler(data: [String : Any], response: HTTPURLResponse?) {
        let mediaFiles = data["data"]
        self.mediaDelegate?.didReceiveMediaSuccessfully(data: mediaFiles as! [Any])
    }
    
    func fetchServiceServerErrorHandler(error: Error?, response: HTTPURLResponse?) {
        print(response?.statusCode)
    }
    
    func fetchServiceClientErrorHandler(error: Error?) {
        
    }
    
    func fetchTokenHandler() {
        
    }
}
