//
//  NetworkProvider.swift
//  FetchChallenge
//
//  Created by Jannis Grimm on 8/22/24.
//

import Foundation

///Implementation of Network tying everything together
final class NetworkProvider: Network {
    public static let shared = NetworkProvider()
    
    let session: Session
    let baseURL: URL
    let decoder: JSONDecoder
    
    init(session: Session = URLSession.shared,
         baseURL: URL = NetworkURL.base,
         decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.baseURL = baseURL
        self.decoder = decoder
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
        guard let url = buildURL(for: NetworkURL.lookup, baseURL: NetworkURL.base, queryItems: [URLQueryItem(name: "i", value: id)]) else {
            throw NetworkError.malformedURL
        }
        let wrapper: MealDetailWrapper = try await fetch(from: url)
        guard let mealDetail = wrapper.mealDetail.first else {
            throw NetworkError.missingData
        }
        return mealDetail
    }
    
    func fetch<T: Decodable>(from url: URL) async throws -> T {
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request, delegate: nil)
        return try decoder.decode(T.self, from: data)
    }
}

