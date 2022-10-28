//
//  FetchDataService.swift
//  GroceryApp
//
//  Created by Navpreet Kailay on 04/10/22.
//

import Foundation

typealias GenericResultClouser<T> = (Result<T, Error>) -> Void


protocol HomeDataSourceService {
//    func fetchdata() -> DecodedFuture<HomeDataModel>
}
