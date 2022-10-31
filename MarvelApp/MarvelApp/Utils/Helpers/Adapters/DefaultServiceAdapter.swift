//
//  DefaultServiceAdapter.swift
//  GroceryApp
//
//  Created by Navpreet Kailay on 04/10/22.
//

import Foundation

struct DefaultServiceAdapter  {
    let networkManager: NetworkManager
    let database: CoreDataManager
    let imageService : ImageLoader
    //     let router: Router
}

 /// Extension of the Service Adapter for Home Screen data and services
extension DefaultServiceAdapter: HomeDataSourceService {
    
    func fetchCharacters(nameStartsWith: String?, limit: Int, offset: Int?) -> DecodedFuture<CharactersModel> {
        return networkManager
            .request(for: CharactersModel.self,
                     endpoint: EndpointCases.characters(nameStartsWith: nameStartsWith,
                                                        limit: limit,
                                                        offset: offset))
    }
    
}


extension DefaultServiceAdapter: ComicsDataSourceService {
    
    func fetchComics(characterId: Int, limit: Int) -> DecodedFuture<ComicsModel> {
        return networkManager
            .request(for: ComicsModel.self,
                     endpoint: EndpointCases.getComics(characterId: characterId,
                                                       limit: limit))
    }
    
}
