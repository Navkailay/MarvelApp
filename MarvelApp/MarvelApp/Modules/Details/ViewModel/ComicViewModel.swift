//
//  ComicViewModel.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 31/10/22.
//

import Foundation

class ComicViewModel {
    
    var comic: MCComic?
    var service : ImageLoaderService?

    init(comic: MCComic? = nil, service: ImageLoaderService? = nil) {
        self.comic = comic
        self.service = service
    }
    // stored properties
    
    var smallThumbnailPath: String {
        guard let thumbnail = comic?.thumbnail else { return ""  }
        return  "\(thumbnail.path ?? "")/\(MarvelImageSizeConfiguration.standard_xlarge.rawValue).\(thumbnail.thumbnailExtension ?? "")"
        
     }
    
    var largeThumbnailPath: String {
        guard let thumbnail = comic?.thumbnail else { return ""  }

       return  "\(thumbnail.path ?? "")/\(MarvelImageSizeConfiguration.portrait_incredible.rawValue).\(thumbnail.thumbnailExtension ?? "")"
    }
}
