//
//  MealDetailDecodingTests.swift
//  FetchChallengeTests
//
//  Created by Jannis Grimm on 8/26/24.
//
import XCTest
@testable import FetchChallenge

class MealDetailDecodingTests: XCTestCase {
    
    func testDecodeValidMealDetail() throws {
        let json = """
        {
            "idMeal": "52772",
            "strMeal": "Apple Frangipan Tart",
            "strInstructions": "Preheat the oven to 200C.",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg",
            "strIngredient1": "Apple",
            "strMeasure1": "1",
            "strIngredient3": "",
            "strMeasure3": ""
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let mealDetail = try decoder.decode(MealDetail.self, from: json)
        
        XCTAssertEqual(mealDetail.id, "52772")
        XCTAssertEqual(mealDetail.name, "Apple Frangipan Tart")
        XCTAssertEqual(mealDetail.instructions, "Preheat the oven to 200C.")
        XCTAssertEqual(mealDetail.mealThumb, URL(string: "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg"))
        XCTAssertEqual(mealDetail.ingredients?.count, 1)
        XCTAssertEqual(mealDetail.ingredients?.first?.title, "Apple")
        XCTAssertEqual(mealDetail.ingredients?.first?.measurement, "1")
    }
    
    func testDecodeMealDetailWithMissingInstructions() throws {
        let json = """
        {
            "idMeal": "52772",
            "strMeal": "Apple Frangipan Tart",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg",
            "strIngredient1": "Apple",
            "strMeasure1": "1",
            "strIngredient2": "Butter",
            "strMeasure2": "200g"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let mealDetail = try decoder.decode(MealDetail.self, from: json)
        
        XCTAssertEqual(mealDetail.id, "52772")
        XCTAssertEqual(mealDetail.name, "Apple Frangipan Tart")
        XCTAssertNil(mealDetail.instructions)  // Instructions should be nil since they are missing
        XCTAssertEqual(mealDetail.mealThumb, URL(string: "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg"))
        XCTAssertEqual(mealDetail.ingredients?.count, 2)
    }
    
    
    func testDecodeMealDetailWithNoIngredients() throws {
        let json = """
        {
            "idMeal": "52772",
            "strMeal": "Apple Frangipan Tart",
            "strInstructions": "Preheat the oven to 200C.",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let mealDetail = try decoder.decode(MealDetail.self, from: json)
        
        XCTAssertEqual(mealDetail.id, "52772")
        XCTAssertEqual(mealDetail.name, "Apple Frangipan Tart")
        XCTAssertEqual(mealDetail.instructions, "Preheat the oven to 200C.")
        XCTAssertEqual(mealDetail.mealThumb, URL(string: "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg"))
        XCTAssertEqual(mealDetail.ingredients?.count, 0)  // No ingredients should be decoded
    }
    
    func testDecodeMealDetailWithEmptyIngredient() throws {
        let json = """
        {
            "idMeal": "52772",
            "strMeal": "Apple Frangipan Tart",
            "strInstructions": "Preheat the oven to 200C.",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg",
            "strIngredient1": "Something",
            "strMeasure1": "",
            "strIngredient2": "Butter",
            "strMeasure2": "200g"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let mealDetail = try decoder.decode(MealDetail.self, from: json)
        
        XCTAssertEqual(mealDetail.id, "52772")
        XCTAssertEqual(mealDetail.name, "Apple Frangipan Tart")
        XCTAssertEqual(mealDetail.instructions, "Preheat the oven to 200C.")
        XCTAssertEqual(mealDetail.mealThumb, URL(string: "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg"))
        XCTAssertEqual(mealDetail.ingredients?.count, 1)  // Only one valid ingredient should be decoded
        XCTAssertEqual(mealDetail.ingredients?.first?.title, "Butter")
        XCTAssertEqual(mealDetail.ingredients?.first?.measurement, "200g")
    }
    
    func testDecodeMealDetailWithMissingOrEmptyMeasurements() throws {
        let json = """
        {
            "idMeal": "52772",
            "strMeal": "Apple Frangipan Tart",
            "strInstructions": "Preheat the oven to 200C.",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg",
            "strIngredient1": "Apple",
            "strMeasure1": "1",
            "strIngredient2": "Butter",
            "strMeasure2": "",
            "strIngredient3": "Sugar",
            "strMeasure3": "200g",
            "strIngredient4": "Flour",
            "strMeasure4": null,
            "strIngredient5": "",
            "strMeasure5": "500g"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let mealDetail = try decoder.decode(MealDetail.self, from: json)
        
        // Ensure only valid ingredient-measurement pairs are included
        XCTAssertEqual(mealDetail.ingredients?.count, 2)
        
        let ingredientTitles = mealDetail.ingredients?.map { $0.title }
        
        // Validate the content of the included ingredients
        XCTAssertTrue(ingredientTitles?.contains("Apple") ?? false)
        XCTAssertTrue(ingredientTitles?.contains("Sugar") ?? false)

        // Ensure invalid pairs (like Butter without measurement and Flour with null measurement) are not included
        XCTAssertFalse(ingredientTitles?.contains("Butter") ?? true)
        XCTAssertFalse(ingredientTitles?.contains("Flour") ?? true)
    }
    
}
