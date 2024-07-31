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
    func fetchCharacters(with ids: [Int], name: String?) -> [CharacterType]?
    func addCharacters(characters: [InputCharacterType])
    func updateBookmark(with id: Int)
    func addComics(comics: [InputComicType], to characterId: Int)
    func fetchComics(for characterId: Int) -> [ComicType]?
    func fetchComic(with comicId: Int) -> ComicType?
    
}

// CoreDataManager conforms to Storable in order to keep the TYPES and Classes lossely coupled
class CoreDataManager: Storable {
    
    typealias ComicType = MCComic
    typealias InputCharacterType = CharacterData
    typealias CharacterType = MCCharacter
    typealias ContextType = NSManagedObjectContext
    static let shared = CoreDataManager(
        managedContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    )
    
    private init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    private var managedContext : NSManagedObjectContext
    
    var characters : [MCCharacter]? {
        let request = MCCharacter.fetchRequest()
        let result = try? managedContext.fetch(request)
        return result
    }
    
    
    private func saveContext(context: NSManagedObjectContext) {
        do {
            try context.save()
            debugPrint("Context successfully saved")
        } catch {
            debugPrint("Failed to save context: \(error)")

        }
         
    }
    
    // MARK: Charaters
    func fetchCharacter(with id: Int) -> MCCharacter?{
        let request = MCCharacter.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        let result = try? managedContext.fetch(request)
        return result?.first
    }
    
    func fetchCharacters(with ids: [Int], name: String?) -> [MCCharacter]? {
        let request = MCCharacter.fetchRequest()
        if let name = name {
            if !name.isEmpty {
                request.predicate = NSPredicate(format: "title CONTAINS[c] %@", name)
            }
        } else {
            request.predicate = NSPredicate(format: "id in %@", ids)
        }
        let result = try? managedContext.fetch(request)
        return result
    }
    
    
    func addCharacters(characters: [CharacterData]) {
        characters.forEach({
            if fetchCharacter(with: $0.id) == nil {
                createCharacter(from: $0)
                saveContext(context: managedContext)
                debugPrint("mcCharacter id: \($0.id) saved")
            } else {
                debugPrint("mcCharacter id: \($0.id) already exist")
            }
        })
    }
    
    func updateBookmark(with id: Int) {
        let character = fetchCharacter(with: id)
        character?.isBookmark = !(character?.isBookmark ?? false)
        saveContext(context: managedContext)
    }
    
    // MARK: Comics
    func fetchComic(with comicId: Int) -> MCComic? {
        let request = MCComic.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", comicId)
        let result = try? managedContext.fetch(request)
        return result?.first
    }
    
    func fetchComics(for characterId: Int) -> [MCComic]?{
        let mCCharacterRequest = MCCharacter.fetchRequest()
        mCCharacterRequest.predicate = NSPredicate(format: "id == %d", characterId)
        if let character = try? managedContext.fetch(mCCharacterRequest).first {
            return character.comics?.objectEnumerator().allObjects as? [MCComic]
        }
        return nil
    }
    
    func addComics(comics: [Comic], to characterId: Int) {
        let character = fetchCharacter(with: characterId)
        comics.forEach({
            if fetchComic(with: $0.id) != nil  {
                debugPrint("comic id: \($0.id) already exist in the database")
            } else {
                let mcComic = createComic(form: $0)
                character?.addToComics(mcComic)
                saveContext(context: managedContext)
                debugPrint("comic id: \($0.id) saved with count: \(String(describing: character?.comics?.count))")            }
        })
    }
}
// MCComic generator
extension CoreDataManager {
    private func createComic(form data: Comic) -> MCComic{
        let mcComic = MCComic(context: managedContext)
        mcComic.id = Int64(data.id)
        mcComic.title = data.title
        mcComic.comicDescription = data.resultDescription
        let mcThumbnail = MCThumbnail(context: managedContext)
        mcThumbnail.thumbnailExtension = data.thumbnail.thumbnailExtension
        mcThumbnail.path = data.thumbnail.path
        mcComic.thumbnail = mcThumbnail
        return mcComic
    }
}

// MCCharacter generater
extension CoreDataManager {
    private func createCharacter(from data: CharacterData) {
        let mcCharacter = MCCharacter(context: managedContext)
        mcCharacter.id = Int64(data.id)
        mcCharacter.title = data.name
        mcCharacter.characterDescription = data.resultDescription
        let mcThumbnail = MCThumbnail(context: managedContext)
        mcThumbnail.thumbnailExtension = data.thumbnail.thumbnailExtension
        mcThumbnail.path = data.thumbnail.path
        mcCharacter.thumbnail = mcThumbnail
    }
}
