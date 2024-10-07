//
//  RecipeDetailViewModel.swift
//  Recipes
//
//  Created by michal zak on 06/10/2024.
//

import SwiftUI

class RecipeDetailViewModel: ObservableObject {
    
    var encryptedData: Data? = nil
    @Published var decryptedRecipe: Recipe?
    @Published var isUnlocked = false
    @Published var errorMessage: AlertItem?
    
    func decodeData() {
        do {
            decryptedRecipe = try decrypt(encryptedData: encryptedData!)
            isUnlocked = true
        } catch {
            errorMessage = AlertItem(message: "Decryption failed: \(error.localizedDescription)")
        }
    }
    
    private func decrypt(encryptedData: Data) throws -> Recipe {
        guard let decodedData = Data(base64Encoded: encryptedData) else {
            throw NSError(domain: "Invalid data", code: 0, userInfo: nil)
        }
        let decoder = JSONDecoder()
        return try decoder.decode(Recipe.self, from: decodedData)  // Return decrypted recipe
    }
}
