//
//  HomeViewModel.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import Foundation
import Combine

class HomeViewModel {
    var sectionModels: [SectionModel] = []
    weak var delegate: HomeViewModelDelegate?
    var service: DefaultServiceAdapter?
    var charactersData : CharactersData?
    private var cancellables = Set<AnyCancellable>()
    
    init(delegate: HomeViewModelDelegate? = nil) {
        self.delegate = delegate
    }
    // setup the models for listing out the results on UI
    func setupSectionModels() {
        //reset
        self.sectionModels.removeAll()
        // append Sections
        self.sectionModels.append(
            SectionModel(headerModel: nil,
                         cellModels: charactersData?.results
                .map({ CharacterCVCViewModel(character: $0,
                                             service: ImageLoaderService(imageLoader: ImageLoader.shared))}) ?? [],
                         footerModel: nil,
                         rowHeight: nil)
        )
    }
    
    func fetchData(search: String?) {
        service?.fetchCharacters(name: search, limit: 30, offset: nil)
            .sink(receiveCompletion: { [weak self] failure in
                guard let self else { return }
                switch failure {
                case .failure(let error):
                    self.delegate?.didFailed(with: FloatError(message: error.localizedDescription, type: .failure))
                case.finished: break
                }
            }, receiveValue: { [weak self] charactersModel in
                guard let self else { return }
                self.charactersData = charactersModel.data
                self.setupSectionModels()
                self.reload()
            }).store(in: &cancellables)
        
    }
}


extension HomeViewModel : SectionDataSource {
    func reload() {
        self.delegate?.refreshData()
    }
    func section(at index: Int) -> SectionModel {
        sectionModels[index]
    }
    
    var sectionCount: Int {
        sectionModels.count
    }
    
    var isEmpty: Bool {
        sectionModels.isEmpty
    }
    
    func itemCount(section: Int) -> Int {
        sectionModels[section].cellModels.count
    }
    
    func item(section: Int, index: Int) -> Any {
        sectionModels[section].cellModels[index]
    }
    
    func rowHeightAt(at section: Int) -> CGFloat? {
        return sectionModels[section].rowHeight
        
    }
    
    typealias SectionType = SectionModel
    
    typealias ErrorType = FloatError
    
}
