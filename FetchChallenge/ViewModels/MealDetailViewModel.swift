//
//  MealDetailViewModel.swift
//  FetchChallenge
//
//  Created by Jannis Grimm on 8/22/24.
//

import Foundation

@Observable class MealDetailViewModel {
    var mealDetails: MealDetail? = nil
    var state: MealDetailState = .loading
    
    private let networkProvider: Network
    
    init(networkProvider: Network = NetworkProvider.shared) {
        self.networkProvider = networkProvider
    }
    
    func fetchMealFor(id: String) async {
        self.state = .loading
        do {
            let meal = try await networkProvider.fetchMealDetails(id: id)
            
            // Check if the fetched meal's ID matches the ID that was passed
            if meal.id != id {
                self.state = .error("The meal ID retrieved from the server does not match the expected ID")
                return
            }
            self.mealDetails = meal
            self.state = .success
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }
}

enum MealDetailState {
    case loading
    case success
    case error(String)
}
