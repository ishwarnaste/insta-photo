//
//  ServiceLayerProtocol.swift
//  cook-pad
//
//  Created by Naste, Ishwar (US - Bengaluru) on 6/12/18.
//  Copyright © 2018 Ishwar Naste. All rights reserved.
//

import UIKit

protocol ServiceLayerProtocol {
    func fetch(requestHeaders: [String:String]?)
    func onDataReceived(data: Data?, response: HTTPURLResponse?)
    func onError(error: Error?, response: HTTPURLResponse?)
    func onClientError(error: Error?)
}

