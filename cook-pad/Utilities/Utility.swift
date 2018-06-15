//
//  Utility.swift
//  cook-pad
//
//  Created by Naste, Ishwar (US - Bengaluru) on 6/14/18.
//  Copyright © 2018 Ishwar Naste. All rights reserved.
//

import UIKit

class Utility: NSObject {
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}
