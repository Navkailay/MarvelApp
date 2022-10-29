//
//  DetailsViewModel.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import Foundation
import Combine
class DetailsViewModel {
    
    var delegate: ViewModelDelegate?
    var characterViewModel: CharacterViewModel?
    var imageService : ImageLoader?
    var service: DefaultServiceAdapter?
    var comicsData: ComicsItem?
    private var cancellables = Set<AnyCancellable>()
    
    init(delegate: ViewModelDelegate? = nil, characterViewModel: CharacterViewModel? = nil, imageService: ImageLoader? = nil, service: DefaultServiceAdapter? = nil) {
        self.delegate = delegate
        self.characterViewModel = characterViewModel
        self.imageService = imageService
        self.service = service
    }
    
    func fetchComics(characterId: Int, limit: Int) {
        service?.fetchComics(characterId: characterId, limit: limit)
            .sink(receiveCompletion: { [weak self] failure in
                guard let self else { return }
                switch failure {
                case .failure(let error):
                    self.delegate?.didFailed(with: FloatError(message: error.localizedDescription, type: .failure))
                case.finished: break
                }
            }, receiveValue: { [weak self] charactersModel in
                guard let self else { return }
                //                self.charactersData = charactersModel.data
                //                self.setupSectionModels()
                self.delegate?.refreshData()
            }).store(in: &cancellables)
    }
}

