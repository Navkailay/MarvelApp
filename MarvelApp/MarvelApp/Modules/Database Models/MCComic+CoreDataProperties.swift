//
//  MCComic+CoreDataProperties.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 30/10/22.
//
//

import Foundation
import CoreData


extension MCComic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MCComic> {
        return NSFetchRequest<MCComic>(entityName: "MCComic")
    }

    @NSManaged public var comicDescription: String?
    @NSManaged public var id: Int64
    @NSManaged public var issueNumber: Int64
    @NSManaged public var title: String?
    @NSManaged public var thumbnail: MCThumbnail?

}

extension MCComic : Identifiable {

}
