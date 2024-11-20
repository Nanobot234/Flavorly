//
//  RecipeViewModel.swift
//  Flavorly
//
//  Created by Nana Bonsu on 11/14/24.
//

import Foundation

/// ViewModel to manage recipes, providing data binding for the UI and handling business logic.
@MainActor
class RecipeViewModel: ObservableObject {
    // MARK: - Properties
    
    /// Service responsible for fetching recipes from the API.
    private let recipeService: RecipeService
    
    /// List of all fetched recipes.
    @Published private(set) var listOfRecipes: [Recipe] = []
    
    /// List of recipes filtered by selected cuisine.
    @Published var filteredRecipes: [Recipe] = []
    
    /// Currently selected cuisine filter, if any.
    @Published var selectedCuisine: CuisineType? = nil
    
    /// Flag indicating whether recipes are being loaded.
    @Published var isLoading = false
    
    /// User-friendly error message for UI display.
    @Published var recipeDataErrorMessage: String = ""
    
    /// Error case identifier for more specific UI handling.
    @Published var recipeErrorCaseNum: Int = 0

    // MARK: - Initializer
    
    /// Initializes the `RecipeViewModel` with the provided service. Useful for testing by dependency injection
    /// - Parameter recipeService: A service instance used for fetching recipes. Defaults to a new instance.
    init(recipeService: RecipeService = RecipeService()) {
        self.recipeService = recipeService
    }
    
    // MARK: - Methods
    
    /// Loads recipes from the API and updates the published properties.
    func loadRecipes() async {
        // Prevent multiple simultaneous loading requests.
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false } // Ensure loading flag is reset.
        
        let result = await recipeService.fetchRecipes()
        
        switch result {
        case .success(let recipeData):
            // Successfully fetched and decoded recipes.
            listOfRecipes = recipeData
            filteredRecipes = recipeData
            recipeDataErrorMessage = ""
            recipeErrorCaseNum = 0
            print("Recipes loaded successfully.")
            
        case .failure(let error):
            // Handle specific and generic errors.
            handleError(error)
        }
    }
    
    /// Filters the recipes based on the selected cuisine.
    /// - Parameter cuisine: The selected `CuisineType` to filter by, or `nil` to clear the filter.
    func filterRecipes(by cuisine: CuisineType?) {
        selectedCuisine = cuisine
        if let cuisine = cuisine {
            filteredRecipes = listOfRecipes.filter { $0.cuisine == cuisine }
        } else {
            filteredRecipes = listOfRecipes
        }
        print("Filtered recipes by cuisine: \(cuisine?.rawValue ?? "All")")
    }
    
    /// Handles errors from the recipe service and updates error-related properties.
    /// - Parameter error: The error returned from the recipe service.
    private func handleError(_ error: Error) {
        if let dataError = error as? DataError {
            // Specific data errors.
            switch dataError {
            case .invalidJSON(let description):
                recipeDataErrorMessage = description
                recipeErrorCaseNum = 1
                
            case .invalidRecipe(let description):
                recipeDataErrorMessage = description
                recipeErrorCaseNum = 2
                
            case .emptyRecipeList:
                recipeDataErrorMessage = "No recipes available. Time to order takeout!"
                recipeErrorCaseNum = 3
            }
        } else {
            // Generic errors.
            recipeDataErrorMessage = "An unexpected error occurred. Please try again later."
            recipeErrorCaseNum = 4
        }
        
        print("Error loading recipes: \(recipeDataErrorMessage)")
    }
}

