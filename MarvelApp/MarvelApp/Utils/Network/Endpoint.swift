//
//  Endpoint.swift
//  GCalendar
//
//  Created by Navpreet Kailay on 18/09/22.
//

import Foundation

enum HTTPMethod: String {
    
    case get = "GET"
    case post = "POST"
}

protocol Endpoint {
    var httpMethod: HTTPMethod { get }
    var baseURLString: String { get }
    var path: String { get }
    var headers: [String: Any]? { get }
    var body: [String: Any]? { get }
}

extension Endpoint {
    // a default extension that creates the full URL
    var url: String {
        return baseURLString + path
    }
    
}
 
