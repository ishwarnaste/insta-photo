//
//  NetworkUtilities.swift
//  cook-pad
//
//  Created by Naste, Ishwar (US - Bengaluru) on 6/13/18.
//  Copyright © 2018 Ishwar Naste. All rights reserved.
//

import Foundation

class NetworkUtilities {
    
    func parseDataFromResponse(data: Data?) -> [String: Any]? {
        var dict: [String:Any]?
        do {
            guard let dataDict = data else { return [:] }
            if let json = try JSONSerialization.jsonObject(with: dataDict, options: .allowFragments) as? [String:Any] {
                dict = json
            }
            else {
                // response is Array, not Dictionary
                guard let jsonStr = String(data: dataDict, encoding: String.Encoding.utf8) else { return [:] }
                dict = self.convertStringToDictionary(text: jsonStr)
            }
            return dict
            
        } catch {
            print("Error while parsing Json Dict: \(error.localizedDescription)")
            return [:]
        }
    }
    
    func parsableData(dict: [String:Any]?) -> Data? {
        do {
            guard let dict = dict else { return nil }
            let  data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            return data as Data
        } catch {
            print("Error while creating parsable Json: \(error.localizedDescription)")
            return nil
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:Any]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let arr = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any]
                let dict = ["count": arr?.count as Any, "users": arr as Any] as [String:Any]
                return dict
            } catch let error as NSError {
                print("Error while converting String to Dict: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
}
