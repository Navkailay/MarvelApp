//
//  DetailsViewModel.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import Foundation
import Combine
import Reachability

class DetailsViewModel {
    
    var delegate: ViewModelDelegate?
    var characterViewModel: CharacterViewModel?
    /// service will be used to inject and use dependencies in and by this viewModel
    var service: DefaultServiceAdapter?
    var reachability = try? Reachability()
    var comicsData: ComicsItem?
    var sectionModels: [SectionModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(delegate: ViewModelDelegate? = nil,
         characterViewModel: CharacterViewModel? = nil,
         service: DefaultServiceAdapter? = nil) {
        self.delegate = delegate
        self.characterViewModel = characterViewModel
        self.service = service
        
        reachability?.whenReachable = { reachability in
            //            self.isReachable = true
        }
        reachability?.whenUnreachable = { _ in
            delegate?.didFailed(with: FloatError(message: Constants.Message.noInternet,
                                                 type: .failure))
            //            self.isReachable = false
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
    func setupSectionModels() {
        //reset
        self.sectionModels.removeAll()
        // append Sections
        guard let id = characterViewModel?.character.id else { return }
        let mcComics = (service?.database.fetchComics(for: Int(id)) ?? [])
        self.sectionModels.append(
            SectionModel(
                headerModel: nil,
                cellModels: mcComics
                    .map({ ComicViewModel(comic: $0, service: ImageLoaderService(imageLoader: ImageLoader.shared))
                    }),
                footerModel: nil,
                itemSize: CGSize(width: 150, height: 200)
            )
        )
    }
    
    /// fetched data from local database or from server if network is aviailable
    func fetchComics(characterId: Int, limit: Int) {
        let savedComics = service?.database.fetchComics(for: characterId)
        if !(savedComics?.isEmpty ?? true) || reachability?.connection == .unavailable {
            debugPrint("fetching comic with charcterId id: \(characterId) locally")
            self.setupSectionModels()
            self.reload()
        } else {
            service?.fetchComics(characterId: characterId, limit: limit)
                .sink(receiveCompletion: { [weak self] failure in
                    guard let self else { return }
                    switch failure {
                    case .failure(let error):
                        self.delegate?.didFailed(with: FloatError(message: error.localizedDescription, type: .failure))
                    case.finished: break
                    }
                }, receiveValue: { [weak self] comicsModel in
                    guard let self else { return }
                    self.service?.database.addComics(comics: comicsModel.data?.results ?? [], to: characterId)
                    self.setupSectionModels()
                    self.delegate?.refreshUI()
                }).store(in: &cancellables)
        }
    }
}


extension DetailsViewModel : SectionDataSource {
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
