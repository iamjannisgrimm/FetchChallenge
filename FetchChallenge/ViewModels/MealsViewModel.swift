//
//  DessertsViewModel.swift
//  FetchChallenge
//
//  Created by Jannis Grimm on 8/22/24.
//

import SwiftUI
import Observation

//@MainActor
@Observable class MealsViewModel {
    private var meals: [Meal] = []
    var state: MealState = .loading
    var searchText: String = ""
    var selectedCategory: Category = .dessert
        
    var noMeals: Bool {
        return displayedMeals.count == 0
    }
    
    var displayedMeals: [Meal] {
         var filteredMeals = meals

         //Sorted alphabetically by default
         filteredMeals.sort { $0.name < $1.name }
        
        //Potentially add more filtering options here

         if !searchText.isEmpty {
             filteredMeals = filteredMeals.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
         }

         return filteredMeals
     }

    private let networkProvider: Network
    
    init(networkProvider: Network = NetworkProvider.shared) {
        self.networkProvider = networkProvider
    }
    
    func fetchMeals() async {
        state = .loading
        
        do {
            meals = try await networkProvider.fetchMeals(for: selectedCategory.rawValue)
            state = .success
        } catch {
            self.state = .error("Failed to load meals: \(error.localizedDescription)")
        }
    }
    
}

enum MealState {
    case loading
    case success
    case error(String)
}

enum Category: String {
    case dessert = "Dessert"
    case seafood = "Seafood"
}

