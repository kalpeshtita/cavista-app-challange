//
//  APIRequestManager.swift
//  cavista-app-challenge
//
//  Created by Kalpesh Tita on 25/09/20.
//  Copyright © 2020 Kalpesh Tita. All rights reserved.
//


import Alamofire
import AlamofireImage
import Foundation
import ObjectMapper

protocol APIEndpoint {
    func endpoint() -> String
    func getDigest() -> String
    func getURLPeremeters() -> String
}

extension APIEndpoint{
    func getURLPeremeters() -> String{
        return ""
    }
}

class APIRequest {
    
    public static let sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120
        configuration.timeoutIntervalForResource = 120
        let manager = Alamofire.Session(configuration: configuration)
        return manager
    }()
        
    class func getServerUrl() -> String {
        let serverURL = Environment().configuration(PlistKey.ServerURL)
        let httpProtocol = Environment().configuration(PlistKey.ConnectionProtocol)
        return httpProtocol + serverURL
    }
}

extension APIRequest {
    
    public static func get<R: Codable & APIEndpoint>(
            request: R,
            onSuccess: @escaping ((_: ModelAPIResponse) -> Void),
            onError: @escaping ((_: ModelAPIError?, _: Error) -> Void)) {
            guard var endpointRequest = self.urlRequest(from: request,HTTPMethod: "GET") else {
                return
            }
            endpointRequest.httpMethod = "GET"
            APIRequest.sessionManager.request(endpointRequest)
                .validate(statusCode: 200..<299)
                .responseJSON { (response) in
                    self.processResponse(response, onSuccess: onSuccess, onError: onError)
            }
        }
    
    
    public static func urlRequest(from request: APIEndpoint,HTTPMethod :String) -> URLRequest? {
        let endpoint = request.endpoint()
        
        guard let endpointUrl = URL(string: "\(getServerUrl())\(endpoint)") else {
            return nil
        }
        
        var endpointRequest = URLRequest(url: endpointUrl)
        endpointRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return endpointRequest
    }
    

    
    public static func processResponse (_ response: AFDataResponse<Any>, onSuccess: ((_: ModelAPIResponse) -> Void), onError: ((_: ModelAPIError?, _: Error) -> Void)) {
        print(
            """
            =============== API response =====================
            Request URL: \( String(describing: response.request?.url ?? nil))
            Response: \(String(data: response.data!, encoding: String.Encoding.utf8)!)
            ==================================================
            """
        )
        switch response.result {
        case .success:
            guard let baseResponse = Mapper<ModelAPIResponse>().map(JSONString: String(data: response.data!, encoding: String.Encoding.utf8)!) else {
                return
            }

           // onSuccess(baseResponse)
            if baseResponse.errorCode as! Int == 0
            {
                onSuccess(baseResponse)
            }
            else
            {
                
                guard let baseError = Mapper<ModelAPIError>().map(JSONString: String(data: response.data!, encoding: String.Encoding.utf8)!) else {
                     let error = NSError(domain: "some_domain", code: 100, userInfo: [NSLocalizedDescriptionKey: "Something Went Wrong, Please try again latter"])
                                   onError(nil, error)
                    return
                }
                
                let error = NSError(domain: "some_domain", code: 100, userInfo: [NSLocalizedDescriptionKey: baseError.errorMessage!])
               onError(baseError, error)

            }

            break
        case .failure(let error):
            guard let baseErrorResponse = Mapper<ModelAPIError>().map(JSONString: String(data: response.data!, encoding: String.Encoding.utf8)!) else {
                onError(nil, error)
                return
            }
            guard response.response?.statusCode != 401 else {
                
                return
            }
            onError(baseErrorResponse, error)
            break
        }
        
    }
    
    public static func getErrorResponse(_ response: AFDataResponse<Any>) -> ModelAPIError? {
        do {
            guard let baseErrorResponse = Mapper<ModelAPIError>().map(JSONString: String(data: try JSONSerialization.data(withJSONObject: response.data!, options: .prettyPrinted), encoding: .utf8)!) else {
                return nil
            }
            return baseErrorResponse
        } catch {
            return nil
        }
    }
}

public enum PlistKey {
    
    case ServerURL
    case APIVersion
    case ConnectionProtocol

    func value() -> String {
        switch self {
        case .ServerURL:
            return "server_url"
        case .APIVersion:
            return "api_version"
        case .ConnectionProtocol:
            return "protocol"
        }
    }
}

public struct Environment {
    
    fileprivate var infoDict: [String: Any] {
        if let dict = Bundle.main.infoDictionary {
            return dict
        } else {
            fatalError("Plist file not found")
        }
    }

    public func configuration(_ key: PlistKey) -> String {
        switch key {
        case .ServerURL:
            if let tmpValue = infoDict[PlistKey.ServerURL.value()] as? String, tmpValue != "" {
                return tmpValue + "/"
            }
            return ""
        case .APIVersion:
            if let tmpValue = infoDict[PlistKey.APIVersion.value()] as? String, tmpValue != "" {
                return tmpValue + "/"
            }
            return ""
        case .ConnectionProtocol:
            if let tmpValue = infoDict[PlistKey.ConnectionProtocol.value()] as? String, tmpValue != "" {
                return tmpValue + "://"
            }
            return ""
        }
    }
}

struct JSON {
    static let encoder = JSONEncoder()
}

extension Encodable {
    subscript(key: String) -> Any? {
        return toDictionary[key]
    }
    var toDictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}
