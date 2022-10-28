//
//  SectionableList.swift
//  GroceryApp
//
//  Created by Navpreet Kailay on 19/10/22.
//

import Foundation

protocol SectionableList {
    var sectionModels : [SectionModel] { get }
 }
 
class SectionModel {
    var headerModel: Any?
    var cellModels: [Any] = []
    var footerModel: Any?
    var rowHeight: CGFloat?
    
    init(headerModel: Any? = nil, cellModels: [Any], footerModel: Any? = nil, rowHeight: CGFloat?) {
        self.headerModel = headerModel
        self.cellModels = cellModels
        self.footerModel = footerModel
        self.rowHeight = rowHeight
    }
}
