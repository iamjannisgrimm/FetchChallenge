//
//  MealDetailView.swift
//  FetchChallenge
//
//  Created by Jannis Grimm on 8/22/24.
//

import SwiftUI

struct MealDetailView: View {
    @StateObject var viewModel = MealDetailViewModel()
    var meal: Meal
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .success:
                mealView
            case .error(let message):
                ErrorView(errorMessage: message)
            }
        }
        .task {
            await viewModel.fetchMealFor(id: meal.id)
        }
        .navigationTitle(meal.name)
        .navigationBarTitleDisplayMode(.inline)
    }
        
    private var mealView: some View {
        List {
            Section {
                thumbnail
            }
            Section {
                mealIngredients
            }
            Section {
                instructions
            }
        }
    }
    
    private var thumbnail: some View {
        ImageView(url: viewModel.mealDetails?.mealThumb, width: nil, height: 200, cornerRadius: 0)
            .containerRelativeFrame(.horizontal) { length, _ in
                length
            }
            .padding(.vertical, -12)
    }
    
    private var mealIngredients: some View {
        VStack {
            title(with: "Ingredients")
            if viewModel.mealDetails?.ingredients?.count == 0 {
                Text("No ingredients :(")
            } else {
                ForEach(viewModel.mealDetails?.ingredients ?? [], id: \.title) { ingredient in
                    HStack {
                        Text(ingredient.title)
                            .fontWeight(.medium)
                        Spacer()
                        Text(ingredient.measurement)
                    }.padding(.vertical, 2)
                }
            }
        }
    }
    
    private var instructions: some View {
        VStack {
            title(with: "Instructions")
            Text(viewModel.mealDetails?.instructions ?? "No instructions :(")
                .font(.body)
        }
    }
    
    private func title(with title: String) -> some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            Spacer()
        }.padding(.bottom, 5)
    }
    
}

#Preview {
    let mockJSON = """
    {
        "meals": [
            {
                "idMeal": "52855",
                "strMeal": "Banana Pancakes",
                "strDrinkAlternate": null,
                "strInstructions": "",
                "strMealThumb": "https://www.themealdb.com/images/media/meals/sywswr1511383814.jpg",
                "strIngredient1": "",
                "strMeasure1": "",
                "strIngredient2": "Sugar",
                "strMeasure2": "1 tsp",
                "strIngredient3": "Salt",
                "strMeasure3": ""
            }
        ]
    }
    """
    let jsonData = mockJSON.data(using: .utf8)!
    let networkProvider = PreviewNetworkProvider(mockData: jsonData)
    let viewModel = MealDetailViewModel(networkProvider: networkProvider)
    
    return MealDetailView(viewModel: viewModel, meal: Meal(id: "52855", name: "Sample Meal"))
}
