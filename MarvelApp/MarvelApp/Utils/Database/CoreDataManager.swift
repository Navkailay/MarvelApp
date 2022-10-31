//
//  CoreDataManager.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 30/10/22.
//

import Foundation
import UIKit
import CoreData

/// for the sake for loosely coupled module and abstraction assosiatedtype's are used in the protocol
protocol Storable {
    associatedtype InputCharacterType
    associatedtype CharacterType
    associatedtype InputComicType
    associatedtype ComicType

     associatedtype ContextType
    func fetchCharacter(with id: Int) -> CharacterType?
    func fetchCharacters(with ids: [Int]) -> [CharacterType]?
    func addCharacters(characters: [InputCharacterType])
    func updateBookmark(with id: Int)
    func addComics(comics: [InputComicType], to characterId: Int)
    func fetchComics(for characterId: Int) -> [ComicType]?
    func fetchComic(with comicId: Int) -> ComicType?

    func saveContext(context: ContextType)
}

// CoreDataManager conforms to Storable in order to keep the TYPES and Classes lossely coupled
class CoreDataManager: Storable {
   
    typealias ComicType = MCComic
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

    func fetchCharacters(with ids: [Int]) -> [MCCharacter]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = MCCharacter.fetchRequest()
        request.predicate = NSPredicate(format: "id in %@", ids)
        let result = try? managedContext.fetch(request)
        return result
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
                debugPrint("mcCharacter id: \($0.id) saved")
            } else {
                debugPrint("mcCharacter id: \($0.id) already exist")
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
    func fetchComic(with comicId: Int) -> MCComic? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = MCComic.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", comicId)
        let result = try? managedContext.fetch(request)
        return result?.first
    }
 
    func fetchComics(for characterId: Int) -> [MCComic]?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let mCCharacterRequest = MCCharacter.fetchRequest()
        mCCharacterRequest.predicate = NSPredicate(format: "id == %d", characterId)
        if let character = try? managedContext.fetch(mCCharacterRequest).first {
            return character.comics?.objectEnumerator().allObjects as? [MCComic]
        }
        return nil
     }
    
    func addComics(comics: [Comic], to characterId: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let character = fetchCharacter(with: characterId)
        comics.forEach({
            if fetchComic(with: $0.id) != nil  {
                debugPrint("comic id: \($0.id) already exist in the database")
            } else {
                let mcComic = MCComic(context: managedContext)
                mcComic.id = Int64($0.id)
                mcComic.title = $0.title
                mcComic.comicDescription = $0.resultDescription
                let mcThumbnail = MCThumbnail(context: managedContext)
                mcThumbnail.thumbnailExtension = $0.thumbnail.thumbnailExtension
                mcThumbnail.path = $0.thumbnail.path
                mcComic.thumbnail = mcThumbnail
                character?.addToComics(mcComic)
                saveContext(context: managedContext)
                debugPrint("comic id: \($0.id) saved with count: \(String(describing: character?.comics?.count))")            }
        })
    }
}
