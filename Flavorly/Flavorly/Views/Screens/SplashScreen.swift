//
//  SplashScreen.swift
//  Flavorly
//
//  Created by Nana Bonsu on 11/20/24.
//

import SwiftUI

struct SplashScreen: View {
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if isActive {
               RecipeListView()
            } else {
                VStack {
                    Image("FlavorlyLogo")
                        .resizable()
                        .frame(width: 170, height: 150)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    
                    
                }
            }
        }
        
        //now show the main view after a few seoncs
        .onAppear {
            
           // self.isFirstLaunch = self.checkIfirstLaunch()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    
                    self.isActive = true
                }
            }
        }
    }
}


#Preview {
    SplashScreen()
}
