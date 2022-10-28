//
//  HomeViewModel.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import Foundation

class HomeViewModel {
    var sectionModels: [SectionModel] = []
    weak var delegate: HomeViewModelDelegate?
 
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
                         cellModels: [
                            CharacterCVCViewModel(character: "AntMan"),
                            CharacterCVCViewModel(character: "SpiderMan"),
                            CharacterCVCViewModel(character: "BatMan"),
                            CharacterCVCViewModel(character: "Superman"),
                            CharacterCVCViewModel(character: "HawkEye"),
                            CharacterCVCViewModel(character: "Dave"),
                            CharacterCVCViewModel(character: "Navpreet"),
                         ],
                         footerModel: nil, rowHeight: nil)
        )
    }
    
    func fetchData(search: String) {
        setupSectionModels()
    }
 }


extension HomeViewModel : SectionDataSource {
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
