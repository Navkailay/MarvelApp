//
//  MCThumbnail+CoreDataProperties.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 30/10/22.
//
//

import Foundation
import CoreData


extension MCThumbnail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MCThumbnail> {
        return NSFetchRequest<MCThumbnail>(entityName: "MCThumbnail")
    }

    @NSManaged public var path: String?
    @NSManaged public var thumbnailExtension: String?

}

extension MCThumbnail : Identifiable {

}
