//
//  Test.swift
//  FetchChallengeTests
//
//  Created by Jannis Grimm on 8/26/24.
//
import XCTest
@testable import FetchChallenge


//Make VM's run on mainactor -- will force to await on every property access
class MealDecodingTests: XCTestCase {
    
    func testDecodeValidMeal() throws {
        let json = """
        {
            "idMeal": "52772",
            "strMeal": "Apple Frangipan Tart",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let meal = try decoder.decode(Meal.self, from: json)
        
        XCTAssertEqual(meal.id, "52772")
        XCTAssertEqual(meal.name, "Apple Frangipan Tart")
        XCTAssertEqual(meal.thumbnailURL, URL(string: "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg"))
    }
    
    func testDecodeMealMissingThumbnail() throws {
        let json = """
        {
            "idMeal": "52772",
            "strMeal": "Apple Frangipan Tart"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let meal = try decoder.decode(Meal.self, from: json)
        
        XCTAssertEqual(meal.id, "52772")
        XCTAssertEqual(meal.name, "Apple Frangipan Tart")
        XCTAssertNil(meal.thumbnailURL) // Should be nil since it’s missing
    }
        
    func testDecodeMealWithInvalidURL() throws {
        let json = """
        {
            "idMeal": "52772",
            "strMeal": "Apple Frangipan Tart",
            "strMealThumb": ""
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let meal = try decoder.decode(Meal.self, from: json)
        
        XCTAssertEqual(meal.id, "52772")
        XCTAssertEqual(meal.name, "Apple Frangipan Tart")
        XCTAssertNil(meal.thumbnailURL) // Should be nil because URL is invalid
    }
}
