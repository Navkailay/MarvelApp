//
//  DetailsViewModel.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import Foundation

class DetailsViewModel {
   
    var delegate: DetailsVCDelegate?
    var characterViewModel: CharacterCVCViewModel?
    var service : ImageLoader?
    
    init(delegate: DetailsVCDelegate? = nil, characterViewModel: CharacterCVCViewModel? = nil, service: ImageLoader? = nil) {
        self.delegate = delegate
        self.characterViewModel = characterViewModel
        self.service = service
    }
}
