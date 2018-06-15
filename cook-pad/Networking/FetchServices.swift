//
//  FetchServices.swift
//  cook-pad
//
//  Created by Naste, Ishwar (US - Bengaluru) on 6/12/18.
//  Copyright © 2018 Ishwar Naste. All rights reserved.
//

import UIKit

public protocol FetchServiceDelegate {
    func fetchServiceHandler(data: [String: Any], response: HTTPURLResponse?)
    func fetchServiceServerErrorHandler(error: Error?, response: HTTPURLResponse?)
    func fetchServiceClientErrorHandler(error: Error?)
    func fetchTokenHandler()
}


public class FetchServices {
    let connectionManager = ConnectionManager.sharedInstance
    internal var requestUrl: String = ""
    internal var params: [String : Any]?
    var accessToken: String = ""
    var postString: String = ""
    
    internal var fetchServiceDelegate: FetchServiceDelegate?
    
    //Image Download
    internal var imageTask: URLSessionDownloadTask?
    
    public func getAccessToken(delegate: FetchServiceDelegate?, param:[String:Any]?, baseUrl: String, postBodyString:String){
        self.fetchServiceDelegate = delegate
        requestUrl = baseUrl
        params = param
        postString = postBodyString
        if baseUrl.isEmpty {
            //throw url error
        }
        else {
            post(requestHeaders: nil)
        }
    }
    
    public func getMedia(delegate: FetchServiceDelegate?, baseUrl: String){
        self.fetchServiceDelegate = delegate
        requestUrl = baseUrl
        if baseUrl.isEmpty {
            //throw url error
        }
        else {
            fetch(requestHeaders: nil)
        }
    }
    
    public func getThumbnailImage(url: URL, completion: @escaping (UIImage?, Error?) -> Void) {
        
        self.imageTask = connectionManager.getImage(url: url, accessToken: accessToken) { (image, error) in
            if error == nil {
                completion(image, nil)
            }
            else {
                print("Image download error::::: \(String(describing: error))")
                completion(nil, error)
            }
        }
    }


}


extension FetchServices: ServiceLayerProtocol {
    
    func post(requestHeaders: [String : String]?) {
        connectionManager.createPostRequestWith(url: requestUrl, params: params, accessToken: accessToken, headers: requestHeaders, callingService: self, postStr: postString)
    }
    
    func fetch(requestHeaders: [String : String]?) {
        connectionManager.createGetRequestWith(url: requestUrl, params: params, accessToken: accessToken, headers: requestHeaders, callingService: self)
    }
    
    func onDataReceived(data: Data?, response: HTTPURLResponse?) {
        
        if let dict = NetworkUtilities().parseDataFromResponse(data: data) {
            OperationQueue.main.addOperation {
                print("Network Pod Library: Fetch Service Response: \(dict)")
                self.fetchServiceDelegate?.fetchServiceHandler(data: dict, response: response)
            }
        }
    }
    
    func onError(error: Error?, response: HTTPURLResponse?) {
        OperationQueue.main.addOperation {
            
            guard let err = error else {
                self.fetchServiceDelegate?.fetchServiceServerErrorHandler(error: nil, response: response)
                return
            }
            
            print("Network Pod Library: Fetch Service Server Error : \(String(describing: error?.localizedDescription))")
            self.fetchServiceDelegate?.fetchServiceServerErrorHandler(error: err, response: nil)
        }
    }
    
    func onClientError(error: Error?) {
        OperationQueue.main.addOperation {
            print("Network Pod Library: Fetch Service Client Error : \(String(describing: error?.localizedDescription))")
            self.fetchServiceDelegate?.fetchServiceClientErrorHandler(error: error)
        }
    }
    
}
