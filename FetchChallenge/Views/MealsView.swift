//
//  ContentView.swift
//  FetchChallenge
//
//  Created by Jannis Grimm on 8/22/24.
//

import SwiftUI

struct MealsView: View {
    @State var viewModel = MealsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                case .success:
                    mealsView
                case .error(let message):
                    ErrorView(errorMessage: message)
                }
            }.navigationTitle(viewModel.selectedCategory.rawValue)
            .animation(.bouncy, value: viewModel.noMeals)

        }.task {
            await viewModel.fetchMeals()
        }
    }
        
    private var mealsView: some View {
        VStack {
            if viewModel.noMeals {
                noMealsView
            } else {
                mealsListView
            }
        }.searchable(text: $viewModel.searchText)
    }
    
    private var mealsListView: some View {
        List(viewModel.displayedMeals, id: \.id) { meal in
            NavigationLink(destination: MealDetailView(meal: meal)) {
                HStack {
                    ImageView(url: meal.thumbnailURL, width: 70, height: 70, cornerRadius: 10)
                    Text(meal.name)
                        .fontWeight(.medium)
                        .padding(.leading, 5)
                }
            }
        }
    }
    
    private var noMealsView: some View {
        Text("No meals found")
    }
    
}

#Preview {
    let mockJSON = """
    {
        "meals": [
            {
                "strMeal": "Apple & Blackberry Crumble",
                "strMealThumb": "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg",
                "idMeal": "52893"
            },
            {
                "strMeal": "Apple Frangipan Tart",
                "strMealThumb": "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg",
                "idMeal": "52768"
            },
            {
                "strMeal": "Bakewell tart",
                "strMealThumb": "https://www.themealdb.com/images/media/meals/wyrqqq1468233628.jpg",
                "idMeal": "52767"
            },
            {
                "strMeal": "Banana Pancakes",
                "idMeal": "52855"
            },
            {
                "strMeal": "Battenberg Cake",
                "strMealThumb": "https://www.themealdb.com/images/media/meals/ywwrsp1511720277.jpg",
                "idMeal": "52894"
            }
        ]
    }
    """
    let jsonData = mockJSON.data(using: .utf8)!
    let networkProvider = PreviewNetworkProvider(mockData: jsonData)
    let viewModel = MealsViewModel(networkProvider: networkProvider)

    return MealsView(viewModel: viewModel)
}
