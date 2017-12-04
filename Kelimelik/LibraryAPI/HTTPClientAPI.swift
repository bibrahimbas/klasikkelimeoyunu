//
//  HTTPClientAPI.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 28.11.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import Foundation
import SwiftyJSON

class HTTPClientAPI {
    static let sharedInstance = HTTPClientAPI()
    let httpClientManager = HTTPClientManager()
    
    private init() {}
    
    func callApi(type: String, completed: @escaping (JSON) -> Void ) {
        httpClientManager.getJson(type: type) { (result) in
            print("callApi \(result)")
            completed(result)
        }
    }
    
}
