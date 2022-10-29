//
//  FetchDataService.swift
//  GroceryApp
//
//  Created by Navpreet Kailay on 04/10/22.
//

import Foundation

typealias GenericResultClouser<T> = (Result<T, Error>) -> Void


protocol HomeDataSourceService {

    func fetchCharacters(name: String?, limit: Int, offset: Int?) -> DecodedFuture<CharactersModel>
    
}
