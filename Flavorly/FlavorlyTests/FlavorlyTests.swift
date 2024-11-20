//
//  FlavorlyTests.swift
//  FlavorlyTests
//
//  Created by Nana Bonsu on 11/15/24.
//

import XCTest
@testable import Flavorly

final class FlavorlyTests: XCTestCase {
    
    var recipesList: [Recipe]!
    
    // MARK: - Setup and Teardown
    
    override func setUpWithError() throws {
        super.setUp()
        recipesList = [
            Recipe(cuisine: .Malaysian, name: "Apam Balik", photo_url_small: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg", uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8", source_url: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtube_url: "https://www.youtube.com/watch?v=6R8ffRRJcrg"),
            Recipe(cuisine: .Italian, name: "Budino Di Ricotta", photo_url_small: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/2cac06b3-002e-4df7-bb08-e15bbc7e552d/small.jpg", uuid: "563dbb27-5323-443c-b30c-c221ae598568", source_url: "https://thehappyfoodie.co.uk/recipes/ricotta-cake-budino-di-ricotta", youtube_url: "https://www.youtube.com/watch?v=6dzd6Ra6sb4"),
            Recipe(cuisine: .Greek, name: "Honey Yogurt Cheesecake", photo_url_small: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/70785def-8f3c-4bc6-b5bd-77053fa8d701/small.jpg", uuid: "98c27533-a823-426d-8639-a2b334ec659a", source_url: "https://www.bbcgoodfood.com/recipes/honey-yogurt-cheesecake", youtube_url: "https://www.youtube.com/watch?v=JE8crtueXs8")
        ]
    }

    override func tearDownWithError() throws {
        recipesList = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testRecipeModelDecoding() throws {
        let json = """
        {
        "cuisine": "Malaysian",
        "name": "Apam Balik",
        "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
        "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
        "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
        "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
        "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let recipe = try decoder.decode(Recipe.self, from: json)
        
        XCTAssertEqual(recipe.cuisine, .Malaysian)
        XCTAssertEqual(recipe.name, "Apam Balik")
        XCTAssertEqual(recipe.source_url, "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")
        XCTAssertEqual(recipe.uuid, "0c6ca6e7-e32a-4053-b824-1dbf749910d8")
    }
    
    func testFilterRecipesByCuisine() throws {
        let filteredRecipes = recipesList.filter { $0.cuisine == .Malaysian }
        
        XCTAssertEqual(filteredRecipes.count, 1)
        XCTAssertEqual(filteredRecipes.first?.name, "Apam Balik")
    }
    
    func testDecodeBadData() throws {
        let badData = """
        {
            "cuisine": "Malaysian",
            "name": "Apam Balik",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(Recipe.self, from: badData)
            XCTFail("Decoding should have failed with bad data.")
        } catch {
            XCTAssertTrue(error is DecodingError, "Expected a DecodingError but got \(error)")
        }
    }
    
    func testRecipeEmptyList() throws {
        let emptyList: [Recipe] = []
        XCTAssertTrue(emptyList.isEmpty, "The recipe list should be empty.")
    }
    
    func testValidRecipe() {
        let validRecipe = Recipe(
            cuisine: .Italian,
            name: "Spaghetti",
            photo_url_small: "https://example.com/spaghetti.jpg",
            uuid: "12345",
            source_url: "https://example.com/spaghetti",
            youtube_url: "https://youtube.com/12345"
        )
        
        XCTAssertTrue(validRecipe.isValidRecipe, "The recipe should be valid when all fields are non-empty.")
    }

    func testRecipeWithEmptyName() {
        let invalidRecipe = Recipe(
            cuisine: .Italian,
            name: "",  // Empty name
            photo_url_small: "https://example.com/spaghetti.jpg",
            uuid: "12345",
            source_url: "https://example.com/spaghetti",
            youtube_url: "https://youtube.com/12345"
        )
        
        XCTAssertFalse(invalidRecipe.isValidRecipe, "The recipe should be invalid if the name is empty.")
    }

    func testRecipeWithOptionalSourceAndYoutubeURLs() {
        let validRecipeWithOptionalFields = Recipe(
            cuisine: .Italian,
            name: "Spaghetti",
            photo_url_small: "https://example.com/spaghetti.jpg",
            uuid: "12345",
            source_url: nil,
            youtube_url: nil
        )
        
        XCTAssertTrue(validRecipeWithOptionalFields.isValidRecipe, "The recipe should be valid even if source_url and youtube_url are nil.")
    }

    
    // MARK: Performance Tests
    func testPerformanceExample() throws {
        self.measure {
            
            _ = recipesList.filter { $0.cuisine == .Italian }
        }
    }
    
    /// Test performace with large dataset of recipes
    func testPerformanceWithLargeDataset() throws {
        let largeDataset = Array(repeating: recipesList.first!, count: 1000)
        self.measure {
            _ = largeDataset.filter { $0.cuisine == .Malaysian }
        }
    }

  
    
    
}
