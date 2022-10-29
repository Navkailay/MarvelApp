//
//  SectionDataSource.swift
//  GroceryApp
//
//  Created by Navpreet Kailay on 19/10/22.
//

import Foundation

protocol SectionDataSource {
    associatedtype SectionType
    associatedtype ErrorType
    
    var sectionCount: Int { get }
    var isEmpty: Bool { get }
    func itemCount(section: Int) -> Int
    func section(at index: Int) -> SectionType
    func item(section: Int, index: Int) -> Any
//    func showError(error: ErrorType)
    func rowHeightAt(at section: Int) -> CGFloat?
}

extension SectionDataSource {
    func reload() {}
    func didSelectRowAt(indexPath: IndexPath) {}
}
