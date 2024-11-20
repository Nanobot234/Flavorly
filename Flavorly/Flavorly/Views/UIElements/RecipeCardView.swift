//
//  RecipeCardView.swift
//  Flavorly
//
//  Created by Nana Bonsu on 11/15/24.
//

import SwiftUI
import UIImageColors
import Kingfisher

struct RecipeCardView: View {
    var recipe: Recipe
    @State private var isExpanded: Bool = false // Tracks if the additional info is shown or hidden
    @State private var gradientColors: [Color] = [Color.gray, Color.gray] // Fallback colors
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack {
            HStack {
                // Load image using Kingfisher
                KFImage(URL(string: recipe.photo_url_small))
                    .onSuccess { result in
                        let uiImage = result.image
                        uiImage.getColors { imageColors in
                            // Ensure there are valid colors before setting the gradient
                            if let imageColors = imageColors {
                                gradientColors = [
                                    Color(imageColors.primary),
                                    Color(imageColors.secondary)
                                ]
                            }
                        }
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .cornerRadius(12)
                    .clipped()
                
                VStack(alignment: .leading) {
                    // Recipe name
                    Text(recipe.name)
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding([.top, .bottom], 8)
                    
                    // Cuisine type
                    Text(recipe.cuisine.rawValue)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 8)
                }
                .padding(.leading, 10)
                
                Spacer()
                
                // Menu button
                VStack {
                    menuButtons
                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 150)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: gradientColors),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding([.top, .bottom], 10)
        }
    }
    
    // Menu buttons for actions
    var menuButtons: some View {
        Menu {
            // Check if sourceURL is valid before creating button
            if let sourceURLString = recipe.source_url, let sourceURL = URL(string: sourceURLString) {
                Button("Visit Website") {
                    openURL(sourceURL)
                }
            }
            
            // Check if youtubeURL is valid before creating button
            if let youtubeURLString = recipe.youtube_url, let youtubeURL = URL(string: youtubeURLString) {
                Button("Watch on YouTube") {
                    openURL(youtubeURL)
                }
            }
        } label: {
            Label("", systemImage: "ellipsis.circle")
                .foregroundColor(.white) // Ensure the menu icon is visible
        }
    }
}

#Preview {
    let sampleRecipe = Recipe(
        cuisine: CuisineType(rawValue: "Italian")!,
        name: "Spaghetti Carbonara",
        photo_url_small: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
        uuid: "fewprjp3ro3r2jow3mrq",
        source_url: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
        youtube_url: nil
    )

    return RecipeCardView(recipe: sampleRecipe)
}

