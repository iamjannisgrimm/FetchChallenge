//
//  MealDetail.swift
//  FetchChallenge
//
//  Created by Jannis Grimm on 8/22/24.
//

import Foundation

/// Assumption: any field can be missing, we set missing ones to nil and handle the UI accordingly,
struct MealDetail: Decodable {
    var id: String?
    var name: String?
    var instructions: String?
    var mealThumb: URL?
    var ingredients: [Ingredient]?

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
        case mealThumb = "strMealThumb"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Check for each value if decodable, else assigned nil
        self.id = try container.decodeIfPresent(String.self, forKey: .id)?.cleaned
        self.name = try container.decodeIfPresent(String.self, forKey: .name)?.cleaned
        self.instructions = try container.decodeIfPresent(String.self, forKey: .instructions)?.cleaned
        
        // Decode thumbnail URL if present
        if let mealThumb = try container.decodeIfPresent(String.self, forKey: .mealThumb),
           let validURL = URL(string: mealThumb) {
            self.mealThumb = validURL
        } else {
            self.mealThumb = nil
        }

        // Dynamically decode ingredients
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var ingredients: [Ingredient] = []

        // Filtering out nil values for ingredients
        for key in dynamicContainer.allKeys {
            // Check if the key corresponds to an ingredient
            if key.stringValue.starts(with: "strIngredient") {
                // Decode the ingredient
                if let ingredient = try dynamicContainer.decodeIfPresent(String.self, forKey: key),
                   !ingredient.isEmpty {
                    
                    // Extract the index from the key (e.g., "strIngredient1" -> "1")
                    let index = key.stringValue.dropFirst("strIngredient".count)
                    let measureKey = DynamicCodingKeys(stringValue: "strMeasure\(index)")!
                    
                    // Decode the corresponding measurement
                    if let measurement = try dynamicContainer.decodeIfPresent(String.self, forKey: measureKey),
                       !measurement.isEmpty {
                        // Only append the ingredient if both ingredient and measurement are non-empty
                        ingredients.append(Ingredient(title: ingredient, measurement: measurement))
                    }
                }
            }
        }
        self.ingredients = ingredients
    }
}

struct Ingredient: Decodable {
    var title: String
    var measurement: String
}

//No reason it's outside of the scope
struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = "\(intValue)"
    }
}

struct MealDetailWrapper: Decodable {
    let mealDetail: [MealDetail]
    
    enum CodingKeys: String, CodingKey {
        case mealDetail = "meals"
    }
}

