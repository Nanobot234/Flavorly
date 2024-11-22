//
//  Redipe.swift
//  Flavorly
//
//  Created by Nana Bonsu on 11/14/24.
//

import Foundation

/// Represents a single recipe, conforming to `Decodable` for JSON parsing and `Identifiable` for SwiftUI compatibility.
struct Recipe: Decodable, Identifiable {
    // Unique identifier for SwiftUI views, derived from `uuid`.
    var id: String { uuid }
    
    /// The cuisine type of the recipe.
    var cuisine: CuisineType
    
    /// The name of the recipe.
    var name: String
    
    /// The URL of the recipe's small-sized photo.
    var  photo_url_small: String
    
    /// A unique identifier for the recipe, typically from the backend.
    var uuid: String
    
    /// An optional URL linking to the recipe's source or detailed instructions.
    var source_url: String?
    
    /// An optional YouTube URL for recipe-related videos.
    var youtube_url: String?
    
    /// A computed property to validate if the `Recipe` object contains all required fields.
    var isValidRecipe: Bool {
        // Ensure essential fields are non-empty.
        return !uuid.isEmpty && !cuisine.rawValue.isEmpty && !name.isEmpty && !photo_url_small.isEmpty
    }
}


/// Represents a collection of recipes, designed to match the strcture of the decoded JSON.
struct Recipes: Decodable {
    /// An array of `Recipe` objects.
    var recipes: [Recipe]
}

