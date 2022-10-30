//
//  MCCharacter+CoreDataProperties.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 30/10/22.
//
//

import Foundation
import CoreData


extension MCCharacter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MCCharacter> {
        return NSFetchRequest<MCCharacter>(entityName: "MCCharacter")
    }

    @NSManaged public var title: String?
    @NSManaged public var characterDescription: String?
    @NSManaged public var id: Int64
    @NSManaged public var comics: NSSet?
    @NSManaged public var thumbnail: NSSet?

}

// MARK: Generated accessors for comics
extension MCCharacter {

    @objc(addComicsObject:)
    @NSManaged public func addToComics(_ value: MCComic)

    @objc(removeComicsObject:)
    @NSManaged public func removeFromComics(_ value: MCComic)

    @objc(addComics:)
    @NSManaged public func addToComics(_ values: NSSet)

    @objc(removeComics:)
    @NSManaged public func removeFromComics(_ values: NSSet)

}

// MARK: Generated accessors for thumbnail
extension MCCharacter {

    @objc(addThumbnailObject:)
    @NSManaged public func addToThumbnail(_ value: MCThumbnail)

    @objc(removeThumbnailObject:)
    @NSManaged public func removeFromThumbnail(_ value: MCThumbnail)

    @objc(addThumbnail:)
    @NSManaged public func addToThumbnail(_ values: NSSet)

    @objc(removeThumbnail:)
    @NSManaged public func removeFromThumbnail(_ values: NSSet)

}

extension MCCharacter : Identifiable {

}
