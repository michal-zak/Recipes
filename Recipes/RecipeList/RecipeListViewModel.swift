//
//  RecipeListViewModel.swift
//  Recipes
//
//  Created by michal zak on 06/10/2024.
//
import SwiftUI
import LocalAuthentication

class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var selectedRecipe: Recipe?
    @Published var errorMessage: AlertItem?
    @Published var encryptedRecipe: Data?
    @Published var isNavigate: Bool = false
    
    private let networkManager = NetworkManager()
    
    func loadRecipes() {
        networkManager.fetchRecipes { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    self.recipes = recipes
                case .failure(let error):
                    self.errorMessage = AlertItem(message: error.localizedDescription)
                }
            }
        }
    }
  
    //when I use simulator and cannot Authenticate, I put lines 42 and 51-54 in comment
    func encryptAndAuthenticate(recipe: Recipe){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to view the recipe."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        do {
                            self.encryptedRecipe = try self.encrypt(recipe: recipe)
                            self.selectedRecipe = recipe
                            self.isNavigate = true
                        } catch {
                            self.errorMessage = AlertItem(message: "Encryption failed")
                            self.isNavigate = false
                        }
                    } else {
                        self.errorMessage = AlertItem(message: "Encryption failed")
                        self.isNavigate = false
                    }
                }
            }
        }
    }

    func encrypt(recipe: Recipe) throws -> Data {
        let encoder = JSONEncoder()
        let data = try encoder.encode(recipe)
        return data.base64EncodedData()
    }
}
