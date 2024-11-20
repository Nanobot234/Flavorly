

//
//  RecipeListView.swift
//  Flavorly
//
//  Created by Nana Bonsu on 11/14/24.
//

import SwiftUI

/// Displays fetched `Recipe` objects in a vertical list view
struct RecipeListView: View {
    @StateObject private var recipeViewModel = RecipeViewModel()
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var showLoadingScreen: Bool = false
    @State private var showNoRecipeErrorAlert: Bool = false
    @State private var showRecipeUnavailableView: Bool = false
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                if recipeViewModel.listOfRecipes.isEmpty && showRecipeUnavailableView {
                    RecipesUnavailableView()
                }
                
                if showLoadingScreen {
                    ActivityIndicator(text: "Loading Recipes")
                        .padding(.bottom, 100)
                        .zIndex(1)
                }
                
                VStack {
                    searchBar
                    filterButtons
                    recipeList
                }
                .refreshable {
                     refreshRecipes()
                }
            }
            .alert("Error Loading Recipes", isPresented: $showNoRecipeErrorAlert) {
                Button("Ok", role: .cancel) {
                    showRecipeUnavailableView = true
                }
            } message: {
                Text(recipeViewModel.recipeDataErrorMessage)
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        refreshRecipes()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .onAppear {
                if recipeViewModel.listOfRecipes.isEmpty {
                    loadRecipes()
                }
            }
            .onChange(of: recipeViewModel.selectedCuisine, { _, newCuisine in
                recipeViewModel.filterRecipes(by: newCuisine)
            })
            .onChange(of: recipeViewModel.recipeErrorCaseNum, { _, num in
                
                if(num == 1 || num  == 2){
                    showNoRecipeErrorAlert = true
                } else {
                    showRecipeUnavailableView = true
                }
                
            })
        }
    }

    // MARK: - Components as Variables

    private var searchBar: some View {
        HStack {
            TextField("Search recipes...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .clipShape(Capsule())
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 1)
        )
        .padding(.horizontal)
        .padding(.vertical, 8)
        
    }

    
    private var filterButtons: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // "All" button
                FilterButton(title: "All", isSelected: recipeViewModel.selectedCuisine == nil) {
                    recipeViewModel.selectedCuisine = nil
                }
                // Cuisine buttons sorted alphabetically
                ForEach(CuisineType.allCases.sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { cuisine in
                    FilterButton(title: cuisine.rawValue, isSelected: recipeViewModel.selectedCuisine == cuisine) {
                        recipeViewModel.selectedCuisine = cuisine
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(Color(UIColor.systemGray6))
    }


    private var recipeList: some View {
        ScrollView {
            LazyVStack {
                ForEach(recipeViewModel.filteredRecipes.filter { recipe in
                    searchText.isEmpty || recipe.name.localizedCaseInsensitiveContains(searchText)
                }) { recipe in
                    RecipeCardView(recipe: recipe)
                        .padding(.horizontal)
                        .padding(.top, 8)
                }
            }
        }
    }

    // MARK: - Helper Functions

    /// Loads the recipes from the API endpoint
    private func loadRecipes() {
        showLoadingScreen = true
        Task {
            try await Task.sleep(nanoseconds: 1_500_000_000)
            await recipeViewModel.loadRecipes()
            showLoadingScreen = false
        }
    }

    /// Refreshes recipes by calling loadRecipes
    private func refreshRecipes()  {
        showLoadingScreen = true
        Task {
        try await Task.sleep(nanoseconds: 1_500_000_000) // to give the user a visible loading experience
        await recipeViewModel.loadRecipes()
        showLoadingScreen = false
     }
        recipeViewModel.selectedCuisine = nil
    }

    /// Handles recipe error cases and updates the appropriate view states
    private func handleRecipeError(num: Int) {
        if num == 1 || num == 2 {
            showNoRecipeErrorAlert = true
        } else {
            showRecipeUnavailableView = true
        }
    }
}

#Preview {
    RecipeListView()
}


//

