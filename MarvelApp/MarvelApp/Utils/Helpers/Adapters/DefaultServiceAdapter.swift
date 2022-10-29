//
//  DefaultServiceAdapter.swift
//  GroceryApp
//
//  Created by Navpreet Kailay on 04/10/22.
//

import Foundation

struct DefaultServiceAdapter  {
     let networkManager: NetworkManager
//     let router: Router
  }


/// Extension of the Service Adapter for Home Screen data and services
extension DefaultServiceAdapter: HomeDataSourceService {
 
    func fetchCharacters(name: String?, limit: Int, offset: Int?) -> DecodedFuture<CharactersModel> {
        return networkManager
            .request(for: CharactersModel.self,
                     endpoint: EndpointCases.characters(name: name,
                                                        limit: limit,
                                                        offset: offset))
    }
    
}
