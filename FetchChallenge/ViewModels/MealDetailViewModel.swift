//
//  MealDetailViewModel.swift
//  FetchChallenge
//
//  Created by Jannis Grimm on 8/22/24.
//

import SwiftUI
import Observation

@Observable class MealDetailViewModel: ObservableObject {
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
