//
//  Meal.swift
//  FetchChallenge
//
//  Created by Jannis Grimm on 8/22/24.
//

import Foundation

/// Assumption: A Meal must consist of an id and name (external and internal identification). The thumbnail is optional and can be broken.
struct Meal: Decodable {
    var id: String
    var name: String
    var thumbnailURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnailURL = "strMealThumb"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Assign empty strings if id or name are missing or empty (will be filtered out later then)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)?.cleaned ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name)?.cleaned ?? ""
        
        // Decode thumbnail URL if present
        if let thumbnailString = try container.decodeIfPresent(String.self, forKey: .thumbnailURL),
           let validURL = URL(string: thumbnailString) {
            self.thumbnailURL = validURL
        } else {
            self.thumbnailURL = nil
        }
    }
}

struct MealWrapper: Decodable {
    let meals: [Meal]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode meals and filter out those with empty id or name
        let decodedMeals = try container.decodeIfPresent([Meal].self, forKey: .meals) ?? []
        self.meals = decodedMeals.filter { !$0.id.isEmpty && !$0.name.isEmpty }
    }
    
    enum CodingKeys: String, CodingKey {
        case meals
    }
}

// Sample Meal instance for previews
extension Meal {
    init(id: String, name: String, thumbnailURL: URL? = nil) {
        self.id = id
        self.name = name
        self.thumbnailURL = thumbnailURL
    }
}

