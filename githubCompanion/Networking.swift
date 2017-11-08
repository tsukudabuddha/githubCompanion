//
//  Networking.swift
//  ProductHunt
//
//  Created by Andrew Tsukuda on 11/1/17.
//  Copyright © 2017 Andrew Tsukuda. All rights reserved.
//

import Foundation

/*
 Parts of a URL
 1. URLSession
 2. BaseUrl -> https://api.producthunt.com/v1/
 3. HTTPMethod
 4. Body?
 5. Headers
 6. Query Parameters
 7. Path
 */

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum Resource {
    case users(username: String)
    
    func httpMethod() -> HTTPMethod {
        switch self {
        case .users:
            return .get
        }
    }
    
    func httpHeader() -> [String: String] {
        switch self {
        case .users:
            return ["Accept": "application/vnd.github.v3+json"]
        }
    }
    
    func path() -> String {
        switch self {
        case .users(let username):
            return "/users/\(username)/events"
        }
    }
}

class Networking {
    let session = URLSession.shared
    let baseUrl = "https://api.github.com"
    
    func getEvents(resource: Resource, completion: @escaping ([Event]) -> Void) {
        let fullPath = baseUrl + resource.path()
        let url = URL(string: fullPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = resource.httpHeader()
        
        session.dataTask(with: request) { (data, resp, err) in
            if let data = data {
                
                let eventContainer = try? JSONDecoder().decode([Event].self, from: data)
            
                if let events = eventContainer {
                    completion(events)
    
                } else {
                    
                    if let httpResponse = resp as! HTTPURLResponse? {
                        let code = httpResponse.statusCode
                        switch code {
                        case 404:
                            print("Input invalid name") // TODO: make it so that the user can see
                        default:
                            break
                        }
                    } else {
                        print("Error: \(String(describing: err))")
                    }
                    
                }
                
            }
        }.resume()
    
    }
    
}
