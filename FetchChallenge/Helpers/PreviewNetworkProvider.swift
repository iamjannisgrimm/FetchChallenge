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
    let baseURL: URL
    let decoder: JSONDecoder
    
    init(mockData: Data, baseURL: URL = NetworkURL.base, error: Error? = nil) {
        self.session = MockSession(data: mockData, error: error)
        self.baseURL = baseURL
        self.decoder = JSONDecoder()
    }
    
    public func fetchMeals(for category: String) async throws -> [Meal] {
        guard let url = buildURL(for: NetworkURL.meals, baseURL: baseURL, queryItems: [URLQueryItem(name: "c", value: category)]) else {
            throw NetworkError.malformedURL
        }
        let wrapper: MealWrapper = try await fetch(from: url)
        guard !wrapper.meals.isEmpty else {
            throw NetworkError.missingData
        }
        return wrapper.meals
    }
    
    public func fetchMealDetails(id: String) async throws -> MealDetail {
        guard let url = buildURL(for: NetworkURL.lookup, baseURL: baseURL, queryItems: [URLQueryItem(name: "i", value: id)]) else {
            throw NetworkError.malformedURL
        }
        let wrapper: MealDetailWrapper = try await fetch(from: url)
        guard let mealDetail = wrapper.mealDetail.first else {
            throw NetworkError.missingData
        }
        return mealDetail
    }
    
    // Generic method to fetch and decode data
    func fetch<T: Decodable>(from url: URL) async throws -> T {
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request, delegate: nil)
        return try decoder.decode(T.self, from: data)
    }
}


final class MockSession: Session {
    private let data: Data
    private let response: URLResponse
    private let error: Error?

    init(data: Data, response: URLResponse = HTTPURLResponse(), error: Error? = nil) {
        self.data = data
        self.response = response
        self.error = error
    }

    func data(for request: URLRequest, delegate: (any URLSessionDelegate)?) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        return (data, response)
    }
}
