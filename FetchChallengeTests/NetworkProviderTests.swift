//
//  NetworkProviderTests.swift
//  FetchChallengeTests
//
//  Created by Jannis Grimm on 8/27/24.
//
import XCTest
@testable import FetchChallenge

class NetworkProviderTests: XCTestCase {

    func testFetchMealsSuccess() async throws {
        // Mock JSON data for a successful response
        let jsonData = """
        {
            "meals": [
                {
                    "idMeal": "12345",
                    "strMeal": "Test Meal",
                    "strMealThumb": "https://www.example.com/meal.jpg"
                }
            ]
        }
        """.data(using: .utf8)!
        
        // Mock HTTP URL response
        let mockResponse = HTTPURLResponse(url: URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
        
        // Create the MockSession with the mock data and response
        let mockSession = MockSession(data: jsonData, response: mockResponse)
        
        // Inject the mock session into the NetworkProvider
        let networkProvider = NetworkProvider(session: mockSession)
        
        // Perform the fetchMeals function
        let meals = try await networkProvider.fetchMeals(for: "Dessert")
        
        // Validate the results
        XCTAssertEqual(meals.count, 1)
        XCTAssertEqual(meals.first?.id, "12345")
        XCTAssertEqual(meals.first?.name, "Test Meal")
    }
    
    func testFetchMealsFailure() async {
        // Simulate a network error
        let mockError = URLError(.badServerResponse)
        let mockSession = MockSession(error: mockError)
        
        // Inject the mock session into the NetworkProvider
        let networkProvider = NetworkProvider(session: mockSession)
        
        do {
            _ = try await networkProvider.fetchMeals(for: "Dessert")
            XCTFail("Expected fetchMeals to throw, but it did not.")
        } catch {
            XCTAssertEqual(error as? URLError, mockError)
        }
    }

}

import Foundation

class MockSession: Session {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    func data(for request: URLRequest, delegate: (any URLSessionDelegate)?) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        return (data ?? Data(), response ?? URLResponse())
    }
}
