//
//  CoreDataManager.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 30/10/22.
//

import Foundation
import UIKit
import CoreData

protocol Storable {
    associatedtype CharacterType
    associatedtype InputCharacterType
    associatedtype ContextType
    func fetchCharacter(with id: Int) -> CharacterType?
    func addCharacters(characters: [InputCharacterType])
    func updateBookmark(with id: Int)
    func saveContext(context: ContextType)
}

// CoreDataManager conforms to Storable in order to keep the TYPES and Classes lossely coupled
class CoreDataManager: Storable {

    typealias InputCharacterType = CharacterData
    typealias CharacterType = MCCharacter
    typealias ContextType = NSManagedObjectContext
    static let shared = CoreDataManager()
    private init() {}
    
    var characters : [MCCharacter]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = MCCharacter.fetchRequest()
        let result = try? managedContext.fetch(request)
        return result
    }
    
    var comics : [MCCharacter] {
        return []
    }
    
    func saveContext(context: NSManagedObjectContext) {
        try? context.save()
    }
    
    // MARK: Charaters
    func fetchCharacter(with id: Int) -> MCCharacter?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = MCCharacter.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        let result = try? managedContext.fetch(request)
        return result?.first
    }

    func addCharacters(characters: [CharacterData]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        characters.forEach({
            if fetchCharacter(with: $0.id) == nil {
                let mcCharacter = MCCharacter(context: managedContext)
                mcCharacter.id = Int64($0.id)
                mcCharacter.title = $0.name
                mcCharacter.characterDescription = $0.resultDescription
                let mcThumbnail = MCThumbnail(context: managedContext)
                mcThumbnail.thumbnailExtension = $0.thumbnail.thumbnailExtension
                mcThumbnail.path = $0.thumbnail.path
                mcCharacter.thumbnail = mcThumbnail
                saveContext(context: managedContext)
                debugPrint("data id: \($0.id) saved")
            } else {
                debugPrint("data id: \($0.id) already exist")
            }
        })
    }
    
    func updateBookmark(with id: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let character = fetchCharacter(with: id)
        character?.isBookmark = !(character?.isBookmark ?? false)
        saveContext(context: managedContext)
    }
    
    // MARK: Comics
    func fetchComics(with id: Int) -> MCComic?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = MCComic.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        let result = try? managedContext.fetch(request)
        return result?.first
    }
}
