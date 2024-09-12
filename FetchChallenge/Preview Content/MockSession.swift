//
//  PreviewNetworkProvider.swift
//  FetchChallenge
//
//  Created by Jannis Grimm on 8/28/24.
//

import Foundation

/// Mock Network Provider for Previews simulation actual Network
final class PreviewNetworkProvider: Network {
    let session: Session
    let decoder: JSONDecoder
    let mockData: Data
    
    init(mockData: Data, error: Error? = nil) {
        self.session = MockSession(data: mockData, error: error)
        self.decoder = JSONDecoder()
        self.mockData = mockData
    }
    
    public func fetchMeals(for category: String) async throws -> [Meal] {
        // Directly decode the mock data into a MealWrapper
        let wrapper = try decoder.decode(MealWrapper.self, from: mockData)
        return wrapper.meals
    }
    
    public func fetchMealDetails(id: String) async throws -> MealDetail {
        // Directly decode the mock data for meal details, filtering based on the id
        let wrapper = try decoder.decode(MealDetailWrapper.self, from: mockData)
        guard let mealDetail = wrapper.mealDetail.first(where: { $0.id == id }) else {
            throw NetworkError.missingData
        }
        return mealDetail
    }
    
    func fetch<T: Decodable>(from url: URL) async throws -> T {
        return try decoder.decode(T.self, from: mockData)
    }

}

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
