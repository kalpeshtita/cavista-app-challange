//
//  ModelAPIResponse.swift
//  cavista-app-challenge
//
//  Created by Kalpesh Tita on 25/09/20.
//  Copyright © 2020 Kalpesh Tita. All rights reserved.
//

import Foundation
import ObjectMapper

class ModelAPIResponse: Mappable {
    
//    var responseException: Any?
//    var isError: Any?
//    var message: Any?
    var result: Any?
    var errorCode: Any?
    var errorMessage: Any?
//    var version: Any?
    var strJsonResult : NSString {
        get {
            var JSONString = ""
            var jsonData: Data!
            if result != nil {
                jsonData = try! JSONSerialization.data(withJSONObject: result as Any, options: JSONSerialization.WritingOptions(rawValue: 0))
                if jsonData != nil {
                    JSONString = ((String(data: jsonData, encoding: String.Encoding.utf8)! as NSString) as String)
                }
            }
            return JSONString as NSString
        }
    }

    required init?(map: Map) {}

    func mapping(map: Map) {
//        responseException       <- map["responseException"]
//        isError                 <- map["isError"]
//        message                 <- map["message"]
        result                  <- map["result"]
//        errorCode                  <- map["errorCode"]
//        errorMessage                  <- map["errorMessage"]
//        version                 <- map["version"]
    }
}

class ModelAPIError: Mappable {
    
        var result: Any?
        var errorCode: Any?
        var errorMessage: Any?
    //    var version: Any?
        var strJsonResult : NSString {
            get {
                var JSONString = ""
                var jsonData: Data!
                if result != nil {
                    jsonData = try! JSONSerialization.data(withJSONObject: result as Any, options: JSONSerialization.WritingOptions(rawValue: 0))
                    if jsonData != nil {
                        JSONString = ((String(data: jsonData, encoding: String.Encoding.utf8)! as NSString) as String)
                    }
                }
                return JSONString as NSString
            }
        }

        required init?(map: Map) {}

        func mapping(map: Map) {
    //        responseException       <- map["responseException"]
    //        isError                 <- map["isError"]
    //        message                 <- map["message"]
            result                  <- map["result"]
//            errorCode                  <- map["errorCode"]
//            errorMessage                  <- map["errorMessage"]
    //        version                 <- map["version"]
        }
}
