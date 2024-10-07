//
//  Recipe.swift
//  Recipes
//
//  Created by michal zak on 06/10/2024.
//

import Foundation

struct Recipe: Codable, Identifiable {
    let id: UUID = UUID() // Unique ID for each recipe
    let name: String
    let thumb: String
    let fats: String
    let calories: String
    let carbos: String
    let image: String
    let description: String
}
