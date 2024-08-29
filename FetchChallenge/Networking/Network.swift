//
//  Network.swift
//  FetchChallenge
//
//  Created by Jannis Grimm on 8/22/24.
//

import Foundation

///Defines key methods and properties that any networking service should have
protocol Network {
    var session: Session { get }
    var decoder: JSONDecoder { get }
    
    func buildURL(for path: String, baseURL url: URL, queryItems: [URLQueryItem]) -> URL?
    
    func fetchMeals(for category: String) async throws -> [Meal]
    func fetchMealDetails(id: String) async throws -> MealDetail
    func fetch<T: Decodable>(from url: URL) async throws -> T
}

extension Network {
    ///Method used to compose the final url
    func buildURL(for path: String, baseURL url: URL, queryItems: [URLQueryItem] = []) -> URL? {
        var components = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: false) //Assuming url.appendingPathComponent(path) results in full valid URL
        components?.queryItems = queryItems
        return components?.url
    }
}

///Any API endpoints can be added in future for efficient scaling
enum NetworkURL {
    public static let base = URL(string: "https://www.themealdb.com/api/json/v1/1/")!
    public static let meals = "filter.php"
    public static let lookup = "lookup.php"
}

///Any network errors that can occur
enum NetworkError: Error {
    case malformedURL
    case unknown(description: String)
    case http(statusCode: Int, description: String)
    case decodingError(description: String)
    case missingData
}
