//
//  UserPost.swift
//  cavista-app-challenge
//
//  Created by Kalpesh Tita on 25/09/20.
//  Copyright © 2020 Kalpesh Tita. All rights reserved.
//

import Foundation
import ObjectMapper

class UserPost : Mappable {
    
    var id : String?
    var type : String?
    var date : String?
    var data : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id      <- map["id"]
        type      <- map["type"]
        date      <- map["date"]
        data      <- map["data"]
    }
    
}

class UserPostAPI : Codable{
    
    init() {
        
    }
}

extension UserPostAPI : APIEndpoint{
    func endpoint() -> String {
        return "challenge.json"
    }
    
    func dispatch(onSuccess successHandler: @escaping ((_: Array<UserPost> ) -> Void), onFailure failureHandler: @escaping ((_: ModelAPIError?, _: Error) -> Void)) {
        
        
        
        APIRequest.get(request: self, onSuccess: { (baseAPIResponse) in
        guard let articles = Mapper<UserPost>().mapArray(JSONString: baseAPIResponse.strJsonResult as String) else {
                return
            }
            successHandler(articles)
        }) { (baseAPIError, error) in
            failureHandler(baseAPIError, error)
        }
    }

    
    
    
}
