//
//  CharacterViewModel.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 31/10/22.
//

import Foundation

class CharacterViewModel {
    var character : MCCharacter
    var service : ImageLoaderService?
    
    init(character: MCCharacter, service: ImageLoaderService? = nil) {
        self.character = character
        self.service = service
    }
    
    var smallThumbnailPath: String {
        guard let thumbnail = character.thumbnail else { return ""  }
        return  "\(thumbnail.path ?? "")/\(MarvelImageSizeConfiguration.standard_xlarge.rawValue).\(thumbnail.thumbnailExtension ?? "")"
        
     }
    
    var largeThumbnailPath: String {
        guard let thumbnail = character.thumbnail else { return ""  }

       return  "\(thumbnail.path ?? "")/\(MarvelImageSizeConfiguration.portrait_incredible.rawValue).\(thumbnail.thumbnailExtension ?? "")"
    }
    
    var characterDescription: String {
        guard let characterDescription = character.characterDescription else { return Constants.Message.noDescription }
        let desc = characterDescription.isEmpty ? Constants.Message.noDescription : characterDescription
        return desc
    }
}

