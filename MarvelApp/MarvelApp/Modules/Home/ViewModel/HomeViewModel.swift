//
//  HomeViewModel.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import Foundation
import Combine
import Reachability

class HomeViewModel {
    weak var delegate: ViewModelDelegate?
    /// service will be used to inject and use dependencies in and by this viewModel
    var service: DefaultServiceAdapter?
    var charactersData : CharactersData?
    var sectionModels: [SectionModel] = []
    var isReachable = true
    var reachability = try? Reachability()
    
    private var cancellables = Set<AnyCancellable>()
    init(delegate: ViewModelDelegate? = nil) {
        self.delegate = delegate
        reachability?.whenReachable = { reachability in
            self.isReachable = true
        }
        reachability?.whenUnreachable = { _ in
            delegate?.didFailed(with: FloatError(message: Constants.Message.noInternet,
                                                 type: .failure))
            self.isReachable = false
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    deinit {
        reachability?.stopNotifier()
    }
    
    /// setup the models for listing out the results on UI
    func setupSectionModels(mcCharacters : [MCCharacter]) {
        //reset
        self.sectionModels.removeAll()

        // append Sections
        self.sectionModels.append(
            SectionModel(
                headerModel: nil,
                cellModels: mcCharacters.map({ CharacterViewModel(character: $0,
                                                                  service: ImageLoaderService(imageLoader: ImageLoader.shared))
                }),
                footerModel: nil,
                itemSize: nil
            )
        )
    }
    
    /// fetched data from local database or from server if network is aviailable
    func fetchData(name: String?, limit: Int, offset: Int?) {
        if reachability?.connection == .unavailable {
            self.setupSectionModels(mcCharacters: service?.database.fetchCharacters(with: [], name: name) ?? [])
            self.reload()
        } else {
            delegate?.didBeginFetching()
            service?.fetchCharacters(nameStartsWith: name, limit: limit, offset: offset)
                .sink(receiveCompletion: { [weak self] failure in
                    guard let self else { return }
                    switch failure {
                    case .failure(let error):
                        self.delegate?.didFailed(with: FloatError(message: error.localizedDescription, type: .failure))
                    case.finished: break
                    }
                    self.reload()
                }, receiveValue: { [weak self] charactersModel in
                    guard let self else { return }
                    self.charactersData = charactersModel.data
                    self.service?.database.addCharacters(characters: self.charactersData?.results ?? [])
                    let savedCharacters = self.service?.database.fetchCharacters(with: self.charactersData?.results?.compactMap({ $0.id }) ?? [], name: nil) ?? []
                    self.setupSectionModels(mcCharacters: savedCharacters)
                    self.reload()
                }).store(in: &cancellables)
        }
    }
}

/// SectionDataSource protocol provides a helpful set of properties and functions for List Datasources
extension HomeViewModel : SectionDataSource {
    func reload() {
        self.delegate?.refreshUI()
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
        return sectionModels[section].itemSize?.height
        
    }
    
    typealias SectionType = SectionModel
    typealias ErrorType = FloatError
    
}
