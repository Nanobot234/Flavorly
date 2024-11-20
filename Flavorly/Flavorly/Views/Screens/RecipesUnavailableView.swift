//
//  RecipesUnavailableView.swift
//  Flavorly
//
//  Created by Nana Bonsu on 11/19/24.
//
import SwiftUI

///  Displays a static screen when recipes cant be dispplyed for the user
struct RecipesUnavailableView: View {
    
    
    var body: some View {
        VStack {
            // Search icon
            Image(systemName: "x.circle")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(Color.gray)
            
            // Title text: "No Recipes"
            Text("No Recipes")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
            
            // Help text explaining the issue
            Text("The recipes are unavailable or can't be loaded now. Please contact support for help.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            // A message to encourage ordering takeout
            Text("Time to order takeout!")
                .font(.body)
                .foregroundColor(.primary)
                .padding(.top, 10)
            
            // Optional help text from external parameter
            
        }
        .padding()
//        .background(Color.background)  // Will adjust based on light/dark mode
        .cornerRadius(20)
        .shadow(radius: 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
    }
}

#Preview {
    RecipesUnavailableView()
}
