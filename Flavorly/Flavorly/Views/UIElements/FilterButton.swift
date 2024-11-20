//
//  FilterButton.swift
//  Flavorly
//
//  Created by Nana Bonsu on 11/18/24.
//

import SwiftUI

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(isSelected ? .white : .blue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.clear)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.blue : Color.gray, lineWidth: 1)
                )
                .animation(.easeInOut(duration: 0.2), value: isSelected) // smoother animation
        }
        .buttonStyle(PlainButtonStyle()) // Prevent default button styles from interfering
    }
}

#Preview {
    // Preview with dynamic interaction
    @State  var isSelected = true
    
    return FilterButton(title: "All", isSelected: isSelected) {
        isSelected.toggle() // Toggle the button state on tap
    }
}

