//
//  DataError.swift
//  Flavorly
//
//  Created by Nana Bonsu on 11/19/24.
//

import Foundation

enum DataError: Error {
    case invalidJSON(description: String)
    case invalidRecipe(description: String)
    case emptyRecipeList


    /// A description of the error, which can be used to display user-friendly error messages.
    var localizedDescription: String {
        switch self {
        case .invalidJSON(let description):
            return "Invalid jSON Data: \(description)"
        case .invalidRecipe(let description):
            return "Failed to populate list: \(description)"
        case .emptyRecipeList:
            return "There are no recipes to display. Try again later"
        }
    }
}

