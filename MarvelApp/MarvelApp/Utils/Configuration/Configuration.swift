//
//  Configuration.swift
//  ManekTechTest
//
//  Created by Navpreet Kailay on 22/09/22.
//

import Foundation

enum MarvelImageSizeConfiguration: String {
    case portrait_xlarge = "portrait_xlarge"
    case standard_xlarge = "standard_xlarge"
    case portrait_incredible = "portrait_incredible"

}
 
struct Configuration {
    static let marvelBaseURL = "https://gateway.marvel.com:443/"
    static let imageBaseURL =  marvelBaseURL + "static/"
    
    struct MarvelImageSizeConfiguration {
        
    }

     struct MarvelAPIAuthorization {
        static var marvelPublicKey : String {
           Bundle.infoPListDictionary(value: "marvelPublicKey")
       }
       
       static var marvelPrivateKey : String {
          Bundle.infoPListDictionary(value: "marvelPrivateKey")
      }
       static var timeStamp : Double {
           return Date().timeIntervalSince1970
       }
       static var marvelHash : String {
           let hash = "\(1)" + marvelPrivateKey + marvelPublicKey
           return hash.MD5
       }
    }
    
  
 }


extension Bundle {

   static func infoPListDictionary (value forKey: String) -> String {
        if let value = Bundle.main.infoDictionary?[forKey] as? String {
            return value
        }
        return ""
    }
}
