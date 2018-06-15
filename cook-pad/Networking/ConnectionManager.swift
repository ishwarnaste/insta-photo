//
//  ConnectionManager.swift
//  cook-pad
//
//  Created by Naste, Ishwar (US - Bengaluru) on 6/12/18.
//  Copyright © 2018 Ishwar Naste. All rights reserved.
//

import UIKit

import Foundation
import UIKit

typealias ImageResult = (UIImage?, Error?) -> Void

class ConnectionManager {
    
    //Mark: Static Properties
    
    static let sharedInstance = ConnectionManager()
    
    //Mark: Properties
    
    private var session: URLSession
    
    var imageCache = NSCache<AnyObject,AnyObject>()
    
    private enum NetworkClientError: Error {
        case ImageData
    }
    
    init() {
        let sessionConfiguration = URLSessionConfiguration.default
        session = URLSession(configuration: sessionConfiguration)
        sessionConfiguration.timeoutIntervalForRequest = 30.0
        sessionConfiguration.timeoutIntervalForResource = 30.0
    }
    
    //Mark: Public Methods
    
    /**
     Method description: POST request
     Parameters: url, params, accessToken, headers, callingService
     */
    func createPostRequestWith(url:String, params:[String:Any]?, accessToken:String?, headers: [String:String]?, callingService:AnyObject, postStr:String) {
        
        var request = self.createRequestWith(url: url, params: params, accessToken: accessToken)
        request?.httpMethod = "POST"
        if let headers = headers {
            for header in headers {
                request?.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        request?.httpBody = postStr.data(using: String.Encoding.utf8)!
        NSLog("Request:\(String(describing: request))")
        guard let req = request else { return }
        self.createSessionWith(request: req, accessToken: accessToken, service: callingService)
    }
    
    /**
     Method description: GET request
     Parameters: url, params, accessToken, headers, callingService
     */
    func createGetRequestWith(url:String, params:[String:Any]?, accessToken:String?, headers: [String:String]?, callingService:AnyObject) {
        
        var request = self.createRequestWith(url: url, params: params, accessToken: accessToken)
        request?.httpMethod = "GET"
        
        if let headers = headers {
            for header in headers {
                request?.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        print("Request:\(String(describing: request))")
        guard let req = request else { return }
        self.createSessionWith(request: req, accessToken: accessToken, service: callingService)
    }
    
    /**
     Method description: Create URLRequest method, returns URLRequest for GET and POST
     Parameters: url, params, accessToken, headers, callingService
     */
    private func createRequestWith(url:String, params:[String:Any]?, accessToken:String?) -> URLRequest? {
        
        if let urlStr = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlReq = URL(string: urlStr)
        {
            var request = URLRequest(url: urlReq)
            
            if let token = accessToken  {
                request.addValue(token, forHTTPHeaderField: "Authorization")
            }
            if let parameters = params {
                request.httpBody = NetworkUtilities().parsableData(dict: parameters)
            }
            return request
        }
        
        return nil
    }
    
    /**
     Method description: Create Session method
     Parameters: request, accessToken, callingService
     */
    private func createSessionWith(request:URLRequest,accessToken:String?, service:AnyObject) {
        let postDataTask = self.session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                if let service = service as? ServiceLayerProtocol {
                    guard let err = error else {return}
                    service.onClientError(error: err)
                }
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode == 200 {
                if let service = service as? ServiceLayerProtocol {
                    service.onDataReceived(data: data, response: httpResponse)
                }
            }
            else {
                if httpResponse?.statusCode == 403,let service = service as? ServiceLayerProtocol {
                    service.onError(error: error, response: httpResponse)
                }
                else if httpResponse?.statusCode == 500,let service = service as? ServiceLayerProtocol {
                    service.onError(error: error, response: httpResponse)
                }
                else {
                    if let service = service as? ServiceLayerProtocol {
                        service.onError(error: error, response: httpResponse)
                    }
                }
            }
        }
        
        postDataTask.resume()
    }
    
    /**
     Method description: Get image with Url coming from the API response. Returns URLSessionDownloadTask
     Parameters: url, ImageResult completion block
     */
    func getImage(url: URL, accessToken: String?, completion: @escaping ImageResult) -> URLSessionDownloadTask? {
        let request = self.createImageRequestWith(url: url, params: nil, accessToken: accessToken)
        
        if let cachedImage = self.imageCache.object(forKey: url as AnyObject) as? UIImage {
            completion(cachedImage, nil)
            return nil
        }
        
        let task = session.downloadTask(with: request) {
            (fileUrl, response, error) in
            guard let fileUrl = fileUrl else {
                OperationQueue.main.addOperation {
                    completion(nil, error)
                }
                return
            }
            // You must move the file or open it for reading before this closure returns or it will be deleted
            if let data = NSData(contentsOf: fileUrl), let image = UIImage(data: data as Data) {
                OperationQueue.main.addOperation {
                    self.imageCache.setObject(image, forKey: url as AnyObject)
                    completion(image, nil)
                }
            } else {
                OperationQueue.main.addOperation {
                    completion(nil, NetworkClientError.ImageData)
                }
            }
        }
        task.resume()
        return task
    }
    
    /**
     Method description: Create image URLRequest method, returns URLRequest
     Parameters: url, params, accessToken
     */
    private func createImageRequestWith(url: URL, params:[String:Any]?, accessToken:String?) -> URLRequest {
        
        var request = URLRequest(url: url)
        
        if let token = accessToken  {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        if let parameters = params {
            request.httpBody = NetworkUtilities().parsableData(dict: parameters)
        }
        request.httpMethod = "GET"
        return request
    }
    
}
