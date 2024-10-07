//
//  RecipeDetailView.swift
//  Recipes
//
//  Created by michal zak on 06/10/2024.
//

import SwiftUI
import LocalAuthentication

struct RecipeDetailView: View {
    @StateObject var viewModel = RecipeDetailViewModel()
    let encryptedData: Data?

    var body: some View {
        VStack {
            if viewModel.isUnlocked, let recipe = viewModel.decryptedRecipe {
                // Show recipe details after decryption
                AsyncImage(url: URL(string: recipe.thumb)) { image in
                    image.resizable()
                         .scaledToFill()
                         .frame(height: 200)
                         .clipped()
                } placeholder: {
                    ProgressView()
                }
                CustomText(text: recipe.name, customFont: "Arial", size: 24, textColor: .black)
                    .padding()
                CustomText(text: "Fats: \(recipe.fats)", customFont: "Arial", size: 18, textColor: .black)
                CustomText(text: "Calories: \(recipe.calories)", customFont: "Arial", size: 18, textColor: .black)
                CustomText(text: "Carbs: \(recipe.carbos)", customFont: "Arial", size: 18, textColor: .black)
                CustomText(text: recipe.description, customFont: "Arial", size: 18, textColor: .black)
                    .padding()
            } else {
                // Unlock button to trigger decryption
                let dataString: String = String(data:encryptedData!, encoding: .utf8)!
                CustomText(text: "encrypt data: \(dataString)", customFont: "Arial", size: 12, textColor: .black)
                    .padding(20)
                Button("Unlock Recipe") {
                    viewModel.encryptedData = encryptedData
                    viewModel.decodeData()
                }
                .padding()
            }
        }
        .navigationTitle("Recipe Details")
        .alert(item: $viewModel.errorMessage) { alertItem in
            Alert(title: Text("Error"), message: Text(alertItem.message), dismissButton: .default(Text("OK")))
        }
    }
   
}
