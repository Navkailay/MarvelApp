//
//  EndpointCases.swift
//  GCalendar
//
//  Created by Navpreet Kailay on 18/09/22.
//

import Foundation

enum EndpointCases: Endpoint {
    case characters(name: String?,
                    limit: Int,
                    offset: Int?)
    case getComics(characterId: Int,
                   limit: Int)
    
    var httpMethod: HTTPMethod {
        switch self {
        case .characters, .getComics: return .get
        }
    }
    
    var baseURLString: String {
        Configuration.marvelBaseURL
    }
    
    var path: String {
        switch self {
   
        case .characters: return "v1/public/characters"
        case .getComics(characterId: let characterId, limit: _): return "/v1/public/characters/\(characterId)/comics"
        }
    }
    
    var headers: [String: Any]? {
           return ["Content-Type": "application/json"]
      }
    
    var body: [String : Any]? {
        var parameters = [String: Any]()
        switch self {
        case .characters(name: let name,
                         limit: let limit,
                         offset: let offset):
            parameters = [
                    "limit": limit, "offset": offset ?? 0]
            if let name = name {
                parameters["name"] = name
            }
        case .getComics(characterId: _,
                        limit: let limit):
            parameters = ["limit": limit]
        }
        
        parameters["ts"] = 1
        parameters["apikey"] = Configuration.MarvelAPIAuthorization.marvelPublicKey
        parameters["hash"] = Configuration.MarvelAPIAuthorization.marvelHash
        return parameters
    }
}


