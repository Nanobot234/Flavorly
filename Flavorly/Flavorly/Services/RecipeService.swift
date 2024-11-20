//
//  RecipeService.swift
//  Flavorly
//
//  Created by Nana Bonsu on 11/14/24.
//


import Foundation

/// Fetches recipe data  from an API endpoint
class RecipeService {
    
    // API endpoints
    private let apiEndpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    private let badDataEndpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    private let emptyDataEndpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    /// Initialize the RecipeService
    init() {}
    
    /// Fetches recipes asynchronously from the API endpoint.
    /// - Returns: A `Result` containing either an array of `Recipe` objects or an `Error`.
    func fetchRecipes() async -> Result<[Recipe], Error> {
        
        guard let url = URL(string: apiEndpoint) else {
                      return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
                  }
        do {
            // Fetch raw data from the API
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decode the JSON data
            let recipesContainer = try JSONDecoder().decode(Recipes.self, from: data)
            
            // Ensure the array of recipes is not empty
            guard !recipesContainer.recipes.isEmpty else {
                return .failure(DataError.emptyRecipeList)
            }
            
            // Filter out invalid recipes
            let validRecipes = recipesContainer.recipes.filter { $0.isValidRecipe }
            guard validRecipes.count == recipesContainer.recipes.count else {
                return .failure(DataError.invalidRecipe(description: "There is an invalid recipe in the list."))
            }
            
            return .success(validRecipes)
        } catch let error as DecodingError {
            // Handle JSON decoding errors
            return .failure(handleDecodingError(error))
        } catch {
            // Handle all other errors (e.g., network issues)
            return .failure(error)
        }
    }
    
    /// Handles decoding errors and maps them to a `DataError`.
    /// - Parameter error: The `DecodingError` encountered during JSON decoding.
    /// - Returns: A `DataError` instance describing the decoding issue.
    private func handleDecodingError(_ error: DecodingError) -> DataError {
        switch error {
        case .dataCorrupted(let context):
            print("Data corrupted: \(context.debugDescription)")
            return .invalidJSON(description: "The data is corrupted and could not be parsed.")
        case .keyNotFound(let key, let context):
            print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
            return .invalidJSON(description: "Missing key '\(key.stringValue)' in JSON.")
        case .typeMismatch(let type, let context):
            print("Type mismatch for type \(type): \(context.debugDescription)")
            return .invalidJSON(description: "Type mismatch in JSON data.")
        case .valueNotFound(let type, let context):
            print("Value of type \(type) not found: \(context.debugDescription)")
            return .invalidJSON(description: "Missing value for type \(type) in JSON.")
        @unknown default:
            fatalError("Unknown decoding error occurred.")
        }
    }
}

