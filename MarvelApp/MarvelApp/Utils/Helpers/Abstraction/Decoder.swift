//
//  Decoder.swift
//  GroceryApp
//
//  Created by Navpreet Kailay on 09/10/22.
//

import Foundation

struct Decoder<T: Decodable> {
 
    static func decode(data: Data) throws -> T  {
            return try JSONDecoder().decode(T.self, from: data)
    }
}
