//
//  ComicsModel.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 30/10/22.
//

import Foundation

// MARK: - ComicsModel
struct ComicsModel: Codable {
    let code: Int?
    let status, copyright, attributionText, attributionHTML: String?
    let etag: String?
    let data: ComicsData?
}

// MARK: - DataClass
struct ComicsData: Codable {
    let offset, limit, total, count: Int?
    let results: [Comic]?
}

// MARK: - Result
struct Comic: Codable {
    let id: Int
    let digitalID: Int?
    let title: String?
    let issueNumber: Int?
    let variantDescription, resultDescription, modified, isbn: String?
    let upc, diamondCode, ean, issn: String?
    let format: String?
    let pageCount: Int?
    let textObjects: [TextObject]?
    let resourceURI: String?
    let urls: [URLElement]?
    let series: Series?
    let variants: [Series]?
    let collections, collectedIssues: [ComicSummary]?
    let dates: [DateElement]?
    let prices: [Price]?
    let thumbnail: Thumbnail
    let images: [Thumbnail]?
    let creators: Creators?
    let characters: Characters?
    let stories: Stories?
    let events: Characters?
    
    enum CodingKeys: String, CodingKey {
        case id
        case digitalID = "digitalId"
        case title, issueNumber, variantDescription
        case resultDescription = "description"
        case modified, isbn, upc, diamondCode, ean, issn, format, pageCount, textObjects, resourceURI, urls, series, variants, collections, collectedIssues, dates, prices, thumbnail, images, creators, characters, stories, events
    }
}

struct ComicSummary: Codable{
    let resourceURI: String?
    let name: String?
}

// MARK: - Characters
struct Characters: Codable {
    let available: Int
    let collectionURI: String
    let items: [Series]
    let returned: Int
}

// MARK: - Series
struct Series: Codable {
    let resourceURI: String
    let name: String
}

// MARK: - Creators
struct Creators: Codable {
    let available: Int
    let collectionURI: String
    let items: [CreatorsItem]
    let returned: Int
}

// MARK: - CreatorsItem
struct CreatorsItem: Codable {
    let resourceURI: String
    let name, role: String
}

// MARK: - DateElement
struct DateElement: Codable {
    let type: String
    let date: String
}

//enum DateType: String, Codable {
//    case digitalPurchaseDate = "digitalPurchaseDate"
//    case focDate = "focDate"
//    case onsaleDate = "onsaleDate"
//    case unlimitedDate = "unlimitedDate"
//}

enum Extension: String, Codable {
    case jpg = "jpg"
}

// MARK: - Price
struct Price: Codable {
    let type: String
    let price: Double
}

enum ItemType: String, Codable {
    case cover = "cover"
    case interiorStory = "interiorStory"
}

// MARK: - TextObject
struct TextObject: Codable {
    let type, language, text: String
}

enum URLType: String, Codable {
    case detail = "detail"
    case inAppLink = "inAppLink"
    case purchase = "purchase"
    case reader = "reader"
}
