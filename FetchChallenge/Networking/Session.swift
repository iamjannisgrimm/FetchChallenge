//
//  Session.swift
//  FetchChallenge
//
//  Created by Jannis Grimm on 8/22/24.
//

import Foundation

///Handling sending and receiving requests and responses
protocol Session {
    func data(for request: URLRequest, delegate: (any URLSessionDelegate)?) async throws -> (Data, URLResponse)
}

extension URLSession: Session {
    /// Actual process of sending a network request and receiving a response
    func data(for request: URLRequest, delegate: (any URLSessionDelegate)?) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: nil)
    }
}
