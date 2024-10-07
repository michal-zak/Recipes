//
//  RecipeListView.swift
//  Recipes
//
//  Created by michal zak on 06/10/2024.
//

import SwiftUI
import LocalAuthentication

struct RecipeListView: View {
    @StateObject var viewModel = RecipeListViewModel()
    @State private var encryptedRecipe: Data?
    @State private var selectedRecipe: Recipe?
    
    var body: some View {
        NavigationView {
            List(viewModel.recipes) { recipe in
                Button {
                    viewModel.encryptAndAuthenticate(recipe: recipe)
                } label: {
                    HStack {
                        AsyncImage(url: URL(string: recipe.thumb)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            CustomText(text: recipe.name, customFont: "Arial", size: 18, textColor: .black)
                                .padding(.bottom, 5)
                            CustomText(text: "Fats: \(recipe.fats)", customFont: "Arial", size: 14, textColor: .black)
                            CustomText(text: "Calories: \(recipe.calories)", customFont: "Arial", size: 14, textColor: .black)
                            CustomText(text: "Carbs: \(recipe.carbos)", customFont: "Arial", size: 14, textColor: .black)                        }
                    }
                }
            }
            .navigationTitle("Recipes")
            .onAppear {
                viewModel.loadRecipes()
            }
            .alert(item: $viewModel.errorMessage) { alertItem in
                Alert(title: Text("Error"), message: Text(alertItem.message), dismissButton: .default(Text("OK")))
            }
            .background(
                // Hidden NavigationLink triggered programmatically
                NavigationLink(destination: RecipeDetailView(encryptedData: viewModel.encryptedRecipe), isActive: $viewModel.isNavigate) {
                    EmptyView()
                }
                    .hidden()
            )
        }
    }
}
